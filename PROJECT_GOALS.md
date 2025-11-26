# GCP Cloud Run Management Project

## Project Overview
This project provides tools and utilities to manage Google Cloud Platform (GCP) features across multiple projects, with an initial focus on Cloud Run services.

## Goals

### Phase 1: Discovery and Inventory
- **Identify Cloud Run Usage**: Scan all GCP projects to determine which ones have Cloud Run services deployed or enabled
- **Generate Inventory**: Create a comprehensive list of projects utilizing Cloud Run features
- **Data Export**: Save project lists to accessible formats for further analysis

### Phase 2: Management and Monitoring (Future)
- Monitor Cloud Run service status across projects
- Track resource usage and costs
- Implement automated reporting

### Phase 3: Automation (Future)
- Automate common Cloud Run operations
- Implement bulk management capabilities
- Create dashboards for visualization

## Current Tasks

### Task 1: Cloud Run Project Detection
**Objective**: Identify all GCP projects that have Cloud Run services enabled or deployed

**Requirements**:
- Use gcloud CLI to query project information
- Check for Cloud Run API enablement
- List active Cloud Run services
- Output results to a text file

**Expected Output**: A text file containing project IDs that use Cloud Run features

## Technical Requirements
- GCP access with appropriate permissions
- gcloud CLI installed at `/home/john/google-cloud-sdk/bin/gcloud`
- Permissions to list projects and query Cloud Run services

## Success Criteria
- Successfully identify all projects with Cloud Run usage
- Generate accurate and up-to-date project lists
- Provide clear documentation for future maintenance
