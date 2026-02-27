#!/bin/bash
set -e

# Parse LinkedIn PDF export into structured YAML resume data
# Usage: ./parse-linkedin-pdf.sh <pdf-file> [output-yaml]

PDF_FILE="${1}"
OUTPUT_FILE="${2:-data/resume.yaml}"

if [ ! -f "$PDF_FILE" ]; then
  echo "Error: PDF file not found: $PDF_FILE"
  echo "Usage: $0 <linkedin-profile.pdf> [output.yaml]"
  exit 1
fi

if ! command -v pdftotext &> /dev/null; then
  echo "Error: pdftotext not found. Install with: brew install poppler"
  exit 1
fi

TMP_TEXT="/tmp/linkedin-$$.txt"
trap "rm -f $TMP_TEXT" EXIT

echo "Extracting text from PDF..."
pdftotext "$PDF_FILE" "$TMP_TEXT"

echo "Parsing LinkedIn data..."
echo "⚠️  This script extracts raw text. You'll need to manually structure it into YAML."
echo ""
echo "Raw text saved to: $TMP_TEXT"
echo "Lines: $(wc -l < "$TMP_TEXT")"
echo "Words: $(wc -w < "$TMP_TEXT")"
echo ""
echo "To view the extracted text:"
echo "  cat $TMP_TEXT"
echo ""
echo "To update your resume:"
echo "  1. Edit data/resume.yaml with the extracted content"
echo "  2. Run: ./scripts/build-resume-formats.sh"
echo ""
echo "Sample YAML structure in: data/resume.yaml"

# Keep the temp file around for manual review
cp "$TMP_TEXT" "${TMP_TEXT}.saved"
echo ""
echo "✓ Extracted text saved to: ${TMP_TEXT}.saved"
