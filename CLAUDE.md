# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Purpose

This is a GCP management tool for discovering and managing Cloud Run services across multiple GCP projects in a large organization (4,667+ projects). The project is in Phase 1: Discovery and Inventory, with future phases planned for monitoring and automation.

## Key Commands

### Discovery Script
```bash
./find-cloudrun-projects.sh
```
Scans all GCP projects for Cloud Run usage. Output is saved to `cloud-run-projects.txt`. The script:
- Lists all accessible GCP projects via gcloud CLI
- Checks each project for Cloud Run API enablement
- Verifies actual Cloud Run service deployments (not just API enablement)
- Processes sequentially (can take hours with 4,667+ projects)

### GCP Authentication
The project uses a custom gcloud installation path:
```bash
/home/john/google-cloud-sdk/bin/gcloud
```

Required permissions:
- `resourcemanager.projects.list` - list projects
- `serviceusage.services.list` - check enabled APIs
- `run.services.list` - list Cloud Run services

## Architecture

### Script Design (`find-cloudrun-projects.sh`)
The discovery script uses a two-stage verification approach:
1. **API Check**: Filters projects by checking if `run.googleapis.com` is enabled
2. **Service Check**: Verifies actual Cloud Run service deployments (avoids false positives from projects with API enabled but no services)

This reduces noise by only identifying projects with active Cloud Run usage, not just API access.

### Output Format
`cloud-run-projects.txt` contains one project ID per line, sorted alphabetically.

## Future Development

Phase 2 and 3 features are documented in `PROJECT_GOALS.md` but not yet implemented:
- Phase 2: Monitoring, cost tracking, automated reporting
- Phase 3: Bulk operations, automation, dashboards

When extending this codebase, follow the phased approach outlined in PROJECT_GOALS.md.
