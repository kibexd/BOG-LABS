# Azure DevOps Pipeline Workflow (BOG LABS)

This document explains how the Azure DevOps pipeline builds and deploys the Business Central AL app using the current repo setup.

## Quick Overview

- **Pipeline definition:** `azure-pipelines.yml`
- **Container provisioning script:** `BOGScript.ps1`
- **Container install flow (optional image-based):** `Dockerfile`
- **Visual reference:** `Azure-BOG.png`

At a high level, the pipeline:
1. Validates the local Business Central container environment.
2. Updates the app version in `app.json`.
3. Downloads symbols and compiles the AL app into a `.app` artifact.
4. Deploys the app directly into the running container.

## Trigger Behavior

The pipeline only runs when code is **committed and pushed** to `main`.

From `azure-pipelines.yml`:
- Triggers on changes to `src/*` and `app.json`.
- Ignores Markdown and docs changes.
- Also runs on pull requests targeting `main`.

## Key Variables (Pipeline)

Defined in `azure-pipelines.yml` under `variables`:

- `AppVersion`: `1.0.0.$(Build.BuildId)` for auto-incremented builds.
- `projectName`, `publisher`: used for packaging and metadata.
- `containerName`, `containerUser`, `containerPassword`: for the running BC container.
- `alcPath`: path to the AL compiler on the build agent.
- `tenantId`, ports for SQL and dev endpoints.

**Important:** keep secrets (like container password) in Azure DevOps variable groups or secrets, not plain text.

## Job 1: Build AL Application

Defined as `BuildALApplication` in `azure-pipelines.yml`.

### Steps:

1. **Checkout source**
   - Clean workspace to avoid stale artifacts.

2. **Validate container environment**
   - Ensures container `$(containerName)` is running.
   - Checks SQL port availability.

3. **Update `app.json` version**
   - Rewrites `version` in `app.json` to `$(AppVersion)`.

4. **Install/Update BcContainerHelper**
   - Required for BC container tooling.

5. **Download symbols**
   - Pulls AL symbols into `.alpackages`.

6. **Compile AL app**
   - Uses `alc.exe` with analyzers.
   - Outputs a `.app` file into the build artifact staging folder.

7. **Publish artifacts**
   - App file is published as `ALApp`.
   - Logs are published as `CompilationLogs`.

## Job 2: Deploy to Business Central Container

Defined as `DeployToBCContainer` and depends on a successful build.

### Steps:

1. **Download build artifact**
   - Retrieves the `.app` file from `ALApp`.

2. **Pre-deployment checks**
   - Verifies container is still running.
   - Lists the artifact contents.

3. **Deploy to container**
   - Loads the app details from `app.json`.
   - Uninstalls old versions if present.
   - Unpublishes old versions.
   - Publishes and installs the new app.
   - Verifies successful installation.

4. **Deployment summary**
   - Prints container IP, BC web client, dev endpoint, SQL access info.

## Container Provisioning (Local)

`BOGScript.ps1` provisions the container:

- Creates a BC container named `boglabs`
- Uses `BcContainerHelper` and `Get-BcArtifactUrl`
- Enables multitenant, sets memory limit, updates hosts
- Builds an image named `boglabs:latest`

This script is typically run **before** pipeline usage to ensure the target container exists and is healthy.

## Dockerfile (Optional Image-Based Install)

`Dockerfile` copies `.app` packages into a container image and installs them at startup using NavAdminTool:

- Copies `.app` files from `./app-package`
- Generates a startup script that:
  - Publishes app
  - Syncs app
  - Installs app

This is not used by the main pipeline, which deploys directly into an already running container. Keep it for image-based flows or local testing.

## Visual Reference

`Azure-BOG.png` shows a simplified pipeline flow:

- Build ID naming
- Variables used for BC server, instance, and app version
- Compile > Publish > Test > Publish test results

Use it as a quick onboarding snapshot, but refer to `azure-pipelines.yml` for the authoritative logic.

## Operational Notes

- The pipeline depends on the build agent having:
  - Docker
  - BcContainerHelper
  - AL compiler at `$(alcPath)`
- The container must be running and reachable.
- If symbols fail to download, compilation may still work using cached symbols.

## Common Troubleshooting

- **Container not running:** start it via `BOGScript.ps1`.
- **ALC path invalid:** update `alcPath` in `azure-pipelines.yml`.
- **App install fails:** check `CompilationLogs` and deployment logs in the pipeline.
- **Version conflicts:** ensure `app.json` is not pinned to a lower version after builds.

