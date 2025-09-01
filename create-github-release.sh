#!/bin/bash

# GitHub Release Creation Script
# Used by: .github/workflows/publish-release.yml
# Usage: ./create-github-release.sh <TAG> <GITHUB_TOKEN>

set -uo pipefail

# Arguments
TAG="${1:-}"
GITHUB_TOKEN="${2:-}"

# Validate arguments
if [ -z "${TAG}" ] || [ -z "${GITHUB_TOKEN}" ]; then
  echo "Error: Missing required arguments"
  echo "Usage: $0 <TAG> <GITHUB_TOKEN>"
  exit 1
fi

# Configuration
GITHUB_API="https://api.github.com"
REPO_OWNER="lithiumtech"
REPO_NAME="flutter_brandmessenger_sdk"

# If TAG is "latest", fetch the actual latest tag from the repository
if [ "$(echo "${TAG}" | tr '[:upper:]' '[:lower:]')" = "latest" ]; then
  echo "Detected 'latest' as version, fetching actual latest tag from ${REPO_NAME}..."
  
  # Get all tags with their commit dates using GraphQL API for better sorting
  GRAPHQL_QUERY='{"query":"query { repository(owner: \"'${REPO_OWNER}'\", name: \"'${REPO_NAME}'\") { refs(refPrefix: \"refs/tags/\", first: 1, orderBy: {field: TAG_COMMIT_DATE, direction: DESC}) { nodes { name } } } }"}'
  
  TAGS_RESPONSE=$(curl -s -X POST \
    -H "Authorization: bearer ${GITHUB_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "${GRAPHQL_QUERY}" \
    "${GITHUB_API}/graphql")
  
  # Extract the most recent tag name
  ACTUAL_TAG=$(echo "${TAGS_RESPONSE}" | grep -o '"name":"[^"]*"' | head -1 | sed 's/"name":"\([^"]*\)"/\1/')
  
  if [ -n "${ACTUAL_TAG}" ] && [ "${ACTUAL_TAG}" != "null" ]; then
    echo "Found latest tag: ${ACTUAL_TAG}"
    TAG="${ACTUAL_TAG}"
  else
    echo "Error: Could not determine latest tag for ${REPO_NAME}"
    exit 1
  fi
fi

echo "Creating GitHub release for version ${TAG}..."

# Step 1: Get the latest release
LATEST_RELEASE=$(curl -s \
  -H "Authorization: token ${GITHUB_TOKEN}" \
  -H "Accept: application/vnd.github+json" \
  "${GITHUB_API}/repos/${REPO_OWNER}/${REPO_NAME}/releases/latest" | \
  grep -o '"tag_name":[[:space:]]*"[^"]*"' | \
  sed 's/"tag_name":[[:space:]]*"\([^"]*\)"/\1/' || echo "")

echo "Current latest release: ${LATEST_RELEASE:-none}"

# Step 2: If current tag is already the latest, exit
if [ "${LATEST_RELEASE}" = "${TAG}" ]; then
  echo "Release ${TAG} already exists and is marked as latest. Nothing to do."
  exit 0
fi

# Step 3: Check if the tag exists as a release
RELEASE_INFO=$(curl -s -w "\n%{http_code}" \
  -H "Authorization: token ${GITHUB_TOKEN}" \
  -H "Accept: application/vnd.github+json" \
  "${GITHUB_API}/repos/${REPO_OWNER}/${REPO_NAME}/releases/tags/${TAG}")

CHECK_STATUS=$(echo "${RELEASE_INFO}" | tail -1)

# Step 4: If release exists, make it latest and exit
if [ "${CHECK_STATUS}" = "200" ]; then
  echo "Release for tag ${TAG} already exists. Updating to latest..."
  
  RELEASE_JSON=$(echo "${RELEASE_INFO}" | sed '$d')
  RELEASE_ID=$(echo "${RELEASE_JSON}" | grep -o '"id":[[:space:]]*[0-9]*' | head -1 | sed 's/"id":[[:space:]]*//')
  
  if [ -n "${RELEASE_ID}" ]; then
    UPDATE_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X PATCH \
      "${GITHUB_API}/repos/${REPO_OWNER}/${REPO_NAME}/releases/${RELEASE_ID}" \
      -H "Authorization: token ${GITHUB_TOKEN}" \
      -H "Accept: application/vnd.github+json" \
      -d '{"make_latest":"true"}')
    
    if [ "${UPDATE_STATUS}" -ge 200 ] && [ "${UPDATE_STATUS}" -lt 300 ]; then
      echo "Successfully updated release to be latest."
    else
      echo "Warning: Failed to update release as latest (status ${UPDATE_STATUS})"
    fi
  fi
  exit 0
fi

if [ "${CHECK_STATUS}" != "404" ]; then
  echo "Warning: unexpected status ${CHECK_STATUS} when checking existing release."
fi

# Step 5: Generate release notes and create release
echo "Creating new release for tag ${TAG}..."

# Build the JSON payload
JSON_PAYLOAD='{"tag_name":"'${TAG}'","name":"'${TAG}'","make_latest":"true"'

if [ -n "${LATEST_RELEASE}" ]; then
  echo "Generating release notes from ${LATEST_RELEASE} to ${TAG}..."
  
  # Generate notes and extract body field directly
  BODY=$(curl -s -X POST \
    "${GITHUB_API}/repos/${REPO_OWNER}/${REPO_NAME}/releases/generate-notes" \
    -H "Authorization: token ${GITHUB_TOKEN}" \
    -H "Accept: application/vnd.github+json" \
    -d '{"tag_name":"'${TAG}'","previous_tag_name":"'${LATEST_RELEASE}'"}' | \
    tr '\n' ' ' | sed 's/.*"body":[[:space:]]*\(".*"\).*/\1/')
  
  # Debug: show first 100 chars of extracted body
  echo "Extracted body (first 100 chars): ${BODY:0:100}..."
  
  if [ -n "${BODY}" ] && [ "${BODY}" != "null" ]; then
    echo "Using notes from ${LATEST_RELEASE} to ${TAG}"
    JSON_PAYLOAD="${JSON_PAYLOAD},\"body\":${BODY}"
  else
    echo "Could not extract notes, creating release without notes"
  fi
else
  echo "No previous release found. Creating release without notes"
fi

# Close the JSON object
JSON_PAYLOAD="${JSON_PAYLOAD}}"

# Create the release and capture response
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST \
  "${GITHUB_API}/repos/${REPO_OWNER}/${REPO_NAME}/releases" \
  -H "Authorization: token ${GITHUB_TOKEN}" \
  -H "Accept: application/vnd.github+json" \
  -d "${JSON_PAYLOAD}")

# Extract status code from last line
CREATE_STATUS=$(echo "${RESPONSE}" | tail -1)
RESPONSE_BODY=$(echo "${RESPONSE}" | sed '$d')

if [ "${CREATE_STATUS}" -ge 200 ] && [ "${CREATE_STATUS}" -lt 300 ]; then
  echo "GitHub Release created successfully for tag ${TAG}."
  echo "Check releases at: https://github.com/${REPO_OWNER}/${REPO_NAME}/releases"
else
  echo "Failed to create release (status ${CREATE_STATUS}). Response:"
  echo "${RESPONSE_BODY}"
  echo ""
  echo "Non-fatal: Unable to create GitHub Release; proceeding without failing the deployment."
fi
