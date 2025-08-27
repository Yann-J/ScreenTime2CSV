#!/bin/sh

# Exit if required environment variables are not set
if [ -z "${DOMAIN}" ] || [ -z "${SECRET}" ]; then
    echo "Error: DOMAIN and SECRET environment variables must be set"
    exit 1
fi

FOLDER="/tmp"
WEBHOOK_URL="https://${DOMAIN}/webhook$([ "${DEBUG:-false}" = "true" ] && echo "-test" || echo "")/screentime-csv-ingest"

echo "Running in debug mode: ${DEBUG:-false} (set DEBUG=true to enable)"
echo "Webhook URL: ${WEBHOOK_URL}"
echo "Writing to: ${FOLDER}/data.csv"

# Extract data
python3 screentime2csv.py -o "${FOLDER}/data.csv"

# Upload to n8n
curl -X POST \
  -H "Content-Type: text/csv" \
  -H "X-Secret: ${SECRET}" \
  --data-binary @"${FOLDER}/data.csv" \
  "$WEBHOOK_URL"
