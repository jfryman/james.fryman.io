#!/bin/bash
set -e

# Build resume in multiple formats from data/resume.yaml
# Outputs to static/jamesfryman-resume.{json,xml,md,pdf,yaml}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
DATA_FILE="$PROJECT_DIR/data/resume.yaml"
OUTPUT_DIR="$PROJECT_DIR/static"
BASENAME="jamesfryman-resume"

echo "Building resume formats from $DATA_FILE..."

# Check for required tools
if ! command -v yq &> /dev/null; then
  echo "Error: yq not found. Install via: brew install yq"
  exit 1
fi

# Copy YAML source
cp "$DATA_FILE" "$OUTPUT_DIR/${BASENAME}.yaml"
echo "✓ YAML: $OUTPUT_DIR/${BASENAME}.yaml"

# Convert YAML → JSON
yq eval -o=json "$DATA_FILE" > "$OUTPUT_DIR/${BASENAME}.json"
echo "✓ JSON: $OUTPUT_DIR/${BASENAME}.json"

# Generate Markdown from YAML
{
  echo "# $(yq '.name' "$DATA_FILE")"
  echo ""
  echo "**$(yq '.title' "$DATA_FILE")**  "
  echo "$(yq '.location' "$DATA_FILE")  "
  echo "$(yq '.email' "$DATA_FILE") · [Website]($(yq '.website' "$DATA_FILE")) · [GitHub]($(yq '.github' "$DATA_FILE")) · [LinkedIn]($(yq '.linkedin' "$DATA_FILE"))"
  echo ""
  echo "## About"
  echo ""
  yq '.about' "$DATA_FILE"
  echo ""
  echo "## Skills"
  echo ""
  yq '.skills[]' "$DATA_FILE" | while read -r skill; do
    echo "- $skill"
  done
  echo ""
  echo "## Experience"
  echo ""
  
  # Parse experience entries
  num_exp=$(yq '.experience | length' "$DATA_FILE")
  for ((i=0; i<num_exp; i++)); do
    echo "### $(yq ".experience[$i].title" "$DATA_FILE")"
    echo "**$(yq ".experience[$i].company" "$DATA_FILE")** · $(yq ".experience[$i].period" "$DATA_FILE")"
    echo ""
    yq ".experience[$i].description" "$DATA_FILE"
    echo ""
  done
  
  echo "## Publications"
  echo ""
  num_pubs=$(yq '.publications | length' "$DATA_FILE")
  for ((i=0; i<num_pubs; i++)); do
    echo "### $(yq ".publications[$i].title" "$DATA_FILE")"
    echo "**$(yq ".publications[$i].publisher" "$DATA_FILE")** · $(yq ".publications[$i].date" "$DATA_FILE")"
    echo ""
    yq ".publications[$i].role" "$DATA_FILE"
    echo ""
  done
  
  echo "## Speaking"
  echo ""
  num_talks=$(yq '.speaking | length' "$DATA_FILE")
  for ((i=0; i<num_talks; i++)); do
    echo "### $(yq ".speaking[$i].title" "$DATA_FILE")"
    event=$(yq ".speaking[$i].event" "$DATA_FILE")
    if [ "$event" != "null" ]; then
      echo "$event · $(yq ".speaking[$i].date" "$DATA_FILE")"
    else
      yq ".speaking[$i].date" "$DATA_FILE"
    fi
    echo ""
    video=$(yq ".speaking[$i].video" "$DATA_FILE")
    if [ "$video" != "null" ]; then
      echo "[▶ Watch]($video)"
      echo ""
    fi
  done
  
  echo "## Volunteer"
  echo ""
  num_vol=$(yq '.volunteer | length' "$DATA_FILE")
  for ((i=0; i<num_vol; i++)); do
    echo "### $(yq ".volunteer[$i].organization" "$DATA_FILE")"
    echo "**$(yq ".volunteer[$i].role" "$DATA_FILE")** · $(yq ".volunteer[$i].period" "$DATA_FILE")"
    echo ""
  done
  
} > "$OUTPUT_DIR/${BASENAME}.md"

echo "✓ Markdown: $OUTPUT_DIR/${BASENAME}.md"

# Generate XML from YAML
{
  echo '<?xml version="1.0" encoding="UTF-8"?>'
  echo '<resume>'
  echo "  <name>$(yq '.name' "$DATA_FILE")</name>"
  echo "  <title>$(yq '.title' "$DATA_FILE")</title>"
  echo "  <location>$(yq '.location' "$DATA_FILE")</location>"
  echo "  <contact>"
  echo "    <email>$(yq '.email' "$DATA_FILE")</email>"
  echo "    <phone>$(yq '.phone' "$DATA_FILE")</phone>"
  echo "    <website>$(yq '.website' "$DATA_FILE")</website>"
  echo "    <github>$(yq '.github' "$DATA_FILE")</github>"
  echo "    <linkedin>$(yq '.linkedin' "$DATA_FILE")</linkedin>"
  echo "  </contact>"
  echo "  <about>$(yq '.about' "$DATA_FILE")</about>"
  
  echo "  <skills>"
  yq '.skills[]' "$DATA_FILE" | while read -r skill; do
    echo "    <skill>$skill</skill>"
  done
  echo "  </skills>"
  
  echo "  <experience>"
  num_exp=$(yq '.experience | length' "$DATA_FILE")
  for ((i=0; i<num_exp; i++)); do
    echo "    <position>"
    echo "      <title>$(yq ".experience[$i].title" "$DATA_FILE")</title>"
    echo "      <company>$(yq ".experience[$i].company" "$DATA_FILE")</company>"
    echo "      <period>$(yq ".experience[$i].period" "$DATA_FILE")</period>"
    echo "      <location>$(yq ".experience[$i].location" "$DATA_FILE")</location>"
    echo "      <description>$(yq ".experience[$i].description" "$DATA_FILE")</description>"
    echo "    </position>"
  done
  echo "  </experience>"
  
  echo "  <publications>"
  num_pubs=$(yq '.publications | length' "$DATA_FILE")
  for ((i=0; i<num_pubs; i++)); do
    echo "    <publication>"
    echo "      <title>$(yq ".publications[$i].title" "$DATA_FILE")</title>"
    echo "      <publisher>$(yq ".publications[$i].publisher" "$DATA_FILE")</publisher>"
    echo "      <date>$(yq ".publications[$i].date" "$DATA_FILE")</date>"
    echo "      <role>$(yq ".publications[$i].role" "$DATA_FILE")</role>"
    echo "    </publication>"
  done
  echo "  </publications>"
  
  echo "  <speaking>"
  num_talks=$(yq '.speaking | length' "$DATA_FILE")
  for ((i=0; i<num_talks; i++)); do
    echo "    <talk>"
    echo "      <title>$(yq ".speaking[$i].title" "$DATA_FILE")</title>"
    event=$(yq ".speaking[$i].event" "$DATA_FILE")
    if [ "$event" != "null" ]; then
      echo "      <event>$event</event>"
    fi
    echo "      <date>$(yq ".speaking[$i].date" "$DATA_FILE")</date>"
    video=$(yq ".speaking[$i].video" "$DATA_FILE")
    if [ "$video" != "null" ]; then
      echo "      <video>$video</video>"
    fi
    echo "    </talk>"
  done
  echo "  </speaking>"
  
  echo "  <volunteer>"
  num_vol=$(yq '.volunteer | length' "$DATA_FILE")
  for ((i=0; i<num_vol; i++)); do
    echo "    <position>"
    echo "      <organization>$(yq ".volunteer[$i].organization" "$DATA_FILE")</organization>"
    echo "      <role>$(yq ".volunteer[$i].role" "$DATA_FILE")</role>"
    echo "      <period>$(yq ".volunteer[$i].period" "$DATA_FILE")</period>"
    echo "    </position>"
  done
  echo "  </volunteer>"
  
  echo '</resume>'
} > "$OUTPUT_DIR/${BASENAME}.xml"

echo "✓ XML: $OUTPUT_DIR/${BASENAME}.xml"

# Generate PDF from Markdown using pandoc
if command -v pandoc &> /dev/null; then
  PATH="/Library/TeX/texbin:$PATH" pandoc "$OUTPUT_DIR/${BASENAME}.md" \
    -f markdown \
    -t pdf \
    --pdf-engine=xelatex \
    -V geometry:margin=1in \
    -V fontsize=11pt \
    -o "$OUTPUT_DIR/${BASENAME}.pdf" 2>/dev/null || {
      echo "⚠️  PDF generation failed (xelatex not found). Install BasicTeX:"
      echo "    brew install --cask basictex"
    }
  
  if [ -f "$OUTPUT_DIR/${BASENAME}.pdf" ]; then
    echo "✓ PDF: $OUTPUT_DIR/${BASENAME}.pdf"
  fi
else
  echo "⚠️  pandoc not found, skipping PDF generation"
fi

echo ""
echo "Resume formats built successfully!"
echo "Files available at:"
echo "  - /${BASENAME}.yaml (YAML source)"
echo "  - /${BASENAME}.json (JSON)"
echo "  - /${BASENAME}.xml (XML)"
echo "  - /${BASENAME}.md (Markdown)"
echo "  - /${BASENAME}.pdf (PDF)"
