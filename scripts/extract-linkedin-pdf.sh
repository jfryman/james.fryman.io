#!/bin/bash
set -e

# Extract text from LinkedIn PDF export
# Usage: ./extract-linkedin-pdf.sh <pdf-file> [output-file]

PDF_FILE="${1}"
OUTPUT_FILE="${2:-/tmp/linkedin-resume.txt}"

if [ ! -f "$PDF_FILE" ]; then
  echo "Error: PDF file not found: $PDF_FILE"
  exit 1
fi

if ! command -v pdftotext &> /dev/null; then
  echo "Error: pdftotext not found. Install with: brew install poppler"
  exit 1
fi

pdftotext "$PDF_FILE" "$OUTPUT_FILE"

echo "✓ Extracted text to: $OUTPUT_FILE"
echo "  Lines: $(wc -l < "$OUTPUT_FILE")"
echo "  Words: $(wc -w < "$OUTPUT_FILE")"
