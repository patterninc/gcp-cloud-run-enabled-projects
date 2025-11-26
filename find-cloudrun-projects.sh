#!/bin/bash

# Script to find GCP projects with Cloud Run enabled
# Output: cloud-run-projects.txt

GCLOUD="/home/john/google-cloud-sdk/bin/gcloud"
OUTPUT_FILE="cloud-run-projects.txt"
TEMP_FILE="cloud-run-projects-temp.txt"

echo "Scanning GCP projects for Cloud Run usage..."
echo "This may take a while due to the number of projects..."
echo ""

# Clear output files
> "$OUTPUT_FILE"
> "$TEMP_FILE"

# Get all project IDs
projects=$($GCLOUD projects list --format="value(projectId)")

total=$(echo "$projects" | wc -l)
current=0

for project in $projects; do
    current=$((current + 1))
    echo -ne "Checking project $current/$total: $project\r"

    # Check if Cloud Run API is enabled
    api_enabled=$($GCLOUD services list --project="$project" --enabled --filter="name:run.googleapis.com" --format="value(name)" 2>/dev/null)

    if [ -n "$api_enabled" ]; then
        # API is enabled, now check if there are any services
        services=$($GCLOUD run services list --project="$project" --platform=managed --format="value(name)" 2>/dev/null | head -1)

        if [ -n "$services" ]; then
            echo "$project" >> "$TEMP_FILE"
        fi
    fi
done

echo ""
echo ""

# Sort and save final results
if [ -f "$TEMP_FILE" ] && [ -s "$TEMP_FILE" ]; then
    sort "$TEMP_FILE" > "$OUTPUT_FILE"
    rm "$TEMP_FILE"

    count=$(wc -l < "$OUTPUT_FILE")
    echo "Found $count projects with Cloud Run services"
    echo "Results saved to: $OUTPUT_FILE"
    echo ""
    echo "Projects with Cloud Run:"
    cat "$OUTPUT_FILE"
else
    echo "No projects with Cloud Run services found"
    rm "$TEMP_FILE" 2>/dev/null
fi
