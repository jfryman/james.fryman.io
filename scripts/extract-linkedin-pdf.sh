#!/bin/bash
set -e

# Extract text from LinkedIn PDF export
# Usage: ./extract-linkedin-pdf.sh <pdf-file> [output-file]
#
# Example:
#   ./extract-linkedin-pdf.sh ~/Downloads/Profile.pdf
#   ./extract-linkedin-pdf.sh ~/Downloads/Profile.pdf resume-text.txt

PDF_FILE="${1}"
OUTPUT_FILE="${2:-linkedin-extracted.txt}"

if [ -z "$PDF_FILE" ]; then
  echo "Usage: $0 <linkedin-profile.pdf> [output.txt]"
  echo ""
  echo "Extracts all text from a LinkedIn PDF export."
  echo "Output file defaults to: linkedin-extracted.txt"
  exit 1
fi

if [ ! -f "$PDF_FILE" ]; then
  echo "Error: PDF file not found: $PDF_FILE"
  exit 1
fi

if ! command -v pdftotext &> /dev/null; then
  echo "Error: pdftotext not found. Install with: brew install poppler"
  exit 1
fi

echo "Extracting text from: $PDF_FILE"
pdftotext "$PDF_FILE" "$OUTPUT_FILE"

echo ""
echo "✓ Extracted text to: $OUTPUT_FILE"
echo "  Lines: $(wc -l < "$OUTPUT_FILE")"
echo "  Words: $(wc -w < "$OUTPUT_FILE")"
echo ""
echo "Next steps:"
echo "  1. Review the text: cat $OUTPUT_FILE"
echo "  2. Update data/resume.yaml with the content"
echo "  3. Rebuild formats: ./scripts/build-resume-formats.sh"
