# Release Runbook: flutter_brandmessenger_sdk

This document outlines the steps to release a new version of the `flutter_brandmessenger_sdk` package to pub.dev.

## Pre-release Checklist

- [ ] Ensure all new features are merged into the `main` branch.
- [ ] Ensure all relevant bug fixes are merged into the `main` branch.
- [ ] Run all tests for the plugin and the example app to ensure they are passing.
- [ ] Manually test the example app on both iOS and Android to confirm functionality.

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

5.  **Create Git Tag:**
    - Create a Git tag for the new version to mark the release point in the repository.
    - Replace `vX.X.X` with the new version number (e.g., `v1.0.1`).
      ```sh
      git tag -a vX.X.X -m "Release version X.X.X"
      ```

6.  **Push Tag to Remote:**
    - Push the newly created tag to the remote repository.
      ```sh
      git push origin vX.X.X
      ```

## Post-release

- [ ] Announce the new release in relevant channels.
- [ ] Monitor for any new issues reported by users.
