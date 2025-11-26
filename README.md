# GCP Cloud Run Enabled Projects

A tool to discover and manage Google Cloud Platform projects that use Cloud Run services.

## Overview

This project helps identify which GCP projects have Cloud Run services deployed across a large organization with multiple projects.

## Files

- `PROJECT_GOALS.md` - Detailed project goals and roadmap
- `find-cloudrun-projects.sh` - Script to scan all GCP projects for Cloud Run usage
- `cloud-run-projects.txt` - Output file containing project IDs with Cloud Run services

## Usage

### Finding Cloud Run Projects

Run the discovery script:

```bash
./find-cloudrun-projects.sh
```

The script will:
1. List all accessible GCP projects
2. Check each project for enabled Cloud Run API
3. Verify if Cloud Run services are actually deployed
4. Save results to `cloud-run-projects.txt`

### Prerequisites

- GCP SDK installed at `/home/john/google-cloud-sdk/bin/gcloud`
- Authenticated with GCP (`gcloud auth login`)
- Appropriate permissions to:
  - List projects
  - Query Cloud Run services
  - Check enabled APIs

### Output

The script generates `cloud-run-projects.txt` containing one project ID per line for all projects with active Cloud Run services.

## Next Steps

See `PROJECT_GOALS.md` for planned features including:
- Resource monitoring and cost tracking
- Automated management operations
- Dashboard visualization
