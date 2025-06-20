#!/bin/bash

# Get the current user's GitHub login
# This ensures the script fetches commits for the authenticated user.
GH_USER="$(gh api user --jq .login)"

# Define the estimated start date of your employment.
# This defaults to approximately 10 years ago from today.
# You can modify this date (e.g., "2015-01-01") for a more precise start.
EMPLOYMENT_START_DATE=$(date -v-10y +"%Y-%m-%d")

# Get today's date in YYYY-MM-DD format.
TODAY_DATE=$(date +"%Y-%m-%d")

# Initialize the current chunk's start date to the employment start date.
CURRENT_CHUNK_START="${EMPLOYMENT_START_DATE}"

# Define the output file name for commit messages
OUTPUT_FILE="commit_messages_IH_tenure.txt"

echo "Starting to fetch commit messages from ${EMPLOYMENT_START_DATE} in 2-year chunks."
echo "Output will be appended to ${OUTPUT_FILE}"
echo "-----------------------------------------------------"

# Loop as long as the current chunk start date is before or equal to today's date.
# The `+%s` format converts dates to Unix timestamps for comparison.
while [[ $(date -j -f "%Y-%m-%d" "$CURRENT_CHUNK_START" +%s) -le $(date -j -f "%Y-%m-%d" "$TODAY_DATE" +%s) ]]; do

    # Calculate the end date for the current 2-year chunk.
    # We add 2 years to the CURRENT_CHUNK_START, then subtract 1 day to make the range inclusive.
    # Example: If CURRENT_CHUNK_START is 2015-01-01, +2 years is 2017-01-01. -1 day is 2016-12-31.
    TWO_YEARS_AHEAD=$(date -v+2y -j -f "%Y-%m-%d" "$CURRENT_CHUNK_START" +"%Y-%m-%d")
    CURRENT_CHUNK_END=$(date -v-1d -j -f "%Y-%m-%d" "$TWO_YEARS_AHEAD" +"%Y-%m-%d")

    # --- ENSURING NO FUTURE DATES ---
    # This crucial check caps the CURRENT_CHUNK_END at TODAY_DATE
    # if the calculated 2-year chunk end date goes into the future.
    if [[ $(date -j -f "%Y-%m-%d" "$CURRENT_CHUNK_END" +%s) -gt $(date -j -f "%Y-%m-%d" "$TODAY_DATE" +%s) ]]; then
        CURRENT_CHUNK_END="${TODAY_DATE}"
    fi

    echo "Fetching commit messages for the period: ${CURRENT_CHUNK_START} to ${CURRENT_CHUNK_END}..."

    # Execute the gh search commits command for the current date range.
    # --author: Filters commits by the determined GitHub user (the committer).
    # --created: Specifies the date range using "start_date..end_date" format.
    # --limit: Sets the maximum number of commits to fetch per chunk (1000).
    # --json: Specifies the fields to retrieve for each commit.
    #   - oid: The commit SHA.
    #   - message: The full commit message.
    #   - committer: Details about the committer, including date.
    #   - repository: Details about the repository where the commit resides.
    # --template: Formats the output for each commit.
    gh search commits \
        --author="${GH_USER}" \
        --created "${CURRENT_CHUNK_START}..${CURRENT_CHUNK_END}" \
        --limit 1000 \
        --json oid,message,committer,repository \
        --template '
{{range .}}
=====================================================
Timestamp:  {{.committer.date}}
Repository: {{.repository.nameWithOwner}}
Commit SHA: {{.oid}}

Message:
{{.message}}

{{end}}' >> "${OUTPUT_FILE}" # '>>' appends output to the file

    # Prepare for the next chunk: the new start date is one day after the current chunk's end date.
    NEXT_CHUNK_START=$(date -v+1d -j -f "%Y-%m-%d" "$CURRENT_CHUNK_END" +"%Y-%m-%d")
    CURRENT_CHUNK_START="${NEXT_CHUNK_START}"

    # Break the loop if the current chunk's end date has reached or passed today's date.
    # This prevents unnecessary iterations once all relevant past commits are fetched.
    if [[ $(date -j -f "%Y-%m-%d" "$CURRENT_CHUNK_END" +%s) -ge $(date -j -f "%Y-%m-%d" "$TODAY_DATE" +%s) ]]; then
        break
    fi

done

echo "-----------------------------------------------------"
echo "All commit messages saved to ${OUTPUT_FILE}"