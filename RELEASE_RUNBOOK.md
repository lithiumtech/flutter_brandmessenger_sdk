# Release Runbook: flutter_brandmessenger_sdk

This document outlines the steps to release a new version of the `flutter_brandmessenger_sdk` package to pub.dev.

## Pre-release Checklist

- [ ] Ensure all new features are merged into the `main` branch.
- [ ] Ensure all relevant bug fixes are merged into the `main` branch.
- [ ] Run all tests for the plugin and the example app to ensure they are passing.
- [ ] Manually test the example app on both iOS and Android to confirm functionality.
- [ ] Review the [Brand Messenger SDK - Pre-Production Testing Documentation](https://www.notion.so/trilogy-enterprises/Brand-Messenger-SDK-Pre-Production-Testing-Documentation-25585e927d318030b25bf7b9cfce60af).

## Release Steps

1.  **Update Version:**
    - Open `pubspec.yaml`.
    - Increment the `version` number according to [Semantic Versioning](https://semver.org/). For example, `1.0.0` -> `1.0.1` for a patch, `1.0.0` -> `1.1.0` for a minor change, `1.0.0` -> `2.0.0` for a major change.

2.  **Update Changelog:**
    - Open `CHANGELOG.md`.
    - Add a new entry for the version you are releasing.
    - List all significant changes, bug fixes, and new features under the new version heading.

3.  **Dry Run Publication:**
    - This command checks if the package is ready to be published without actually publishing it.
    - In the project root directory, run:
      ```sh
      flutter pub publish --dry-run
      ```
    - Resolve any errors or warnings that appear.

4.  **Publish Package:**
    - Once the dry run is successful, publish the package to pub.dev.
    - Run the following command and follow the prompts:
      ```sh
      flutter pub publish
      ```

5.  **Create Tag and GitHub Release:**

    #### Option A: CLI Tag + GitHub Release (Two Steps)
    ```sh
    # Create and push tag
    git tag -a vX.X.X -m "Release version X.X.X"
    git push origin vX.X.X
    ```
    Then create a release for the existing tag:
    1. Navigate to `https://github.com/lithiumtech/flutter_brandmessenger_sdk/releases`
    2. Click **"Draft a new release"**
    3. Select the existing tag from the dropdown
    4. Add release title and notes
    5. Click **"Publish release"**

    #### Option B: GitHub UI (Tag + Release in One Step)
    1. Navigate to the repository's **Releases** page: `https://github.com/lithiumtech/flutter_brandmessenger_sdk/releases`
    2. Click **"Draft a new release"**
    3. **Create new tag**: Type your new tag name (e.g., `v1.0.1`) and select **"Create new tag on publish"**
    4. **Target Branch**: Select the branch to create the release from (usually `main`)
    5. **Release Title**: Enter a descriptive title (e.g., `Flutter SDK v1.0.1`)
    6. **Release Notes**: Click **"Generate release notes"** for automatic changelog
    7. Click **"Publish release"** to create both tag and release simultaneously

## Post-release

- [ ] Announce the new release in relevant channels.
- [ ] Monitor for any new issues reported by users.
