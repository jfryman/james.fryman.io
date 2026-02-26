#!/bin/bash
set -e

# Build resume in multiple formats from data/resume.yaml
# Outputs to static/resume.{json,xml,md,pdf,yaml}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
DATA_FILE="$PROJECT_DIR/data/resume.yaml"
OUTPUT_DIR="$PROJECT_DIR/static"

echo "Building resume formats from $DATA_FILE..."

# Copy YAML source
cp "$DATA_FILE" "$OUTPUT_DIR/resume.yaml"
echo "✓ YAML: $OUTPUT_DIR/resume.yaml"

# Convert YAML → JSON
if command -v yq &> /dev/null; then
  yq eval -o=json "$DATA_FILE" > "$OUTPUT_DIR/resume.json"
  echo "✓ JSON: $OUTPUT_DIR/resume.json"
else
  echo "⚠️  yq not found, skipping JSON generation (brew install yq)"
fi

# Generate Markdown from YAML
cat > "$OUTPUT_DIR/resume.md" <<'EOF'
# James Fryman

**Engineering Leader & DevOps Architect**  
Nashville, TN  
james@fryman.io · [Website](https://james.fryman.io) · [GitHub](https://github.com/jfryman) · [LinkedIn](https://www.linkedin.com/in/jamesfryman)

## About

Engineering leader and DevOps architect who bridges the gap between technical excellence and business impact. Public speaker, author, open source contributor, and mentor based in Nashville, TN.

## Experience

### TODO: Current Role Title
**TODO: Company Name** · TODO: Date Range

TODO: Description of current role

### TODO: Previous Role Title
**TODO: Company Name** · TODO: Date Range

TODO: Description

### TODO: Previous Role Title
**TODO: Company Name** · TODO: Date Range

TODO: Description

### TODO: Previous Role Title
**TODO: Company Name** · TODO: Date Range

TODO: Description

## Publications

### "ChatOps for Dummies"
**Wiley Publishing** · April 2015

Wrote foreword and contributed.

### "Puppet Cookbook, 3rd Edition"
**Packt Publishing** · February 2015

Technical reviewer.

### "Puppet Reporting and Monitoring"
**Packt Publishing** · June 2014

Technical reviewer.

## Speaking

### "ChatOps: Technology and Philosophy"
January 2015

[▶ Watch on YouTube](https://www.youtube.com/watch?v=37LmuHToYjQ)

### "DevOps: Day 2 — People and Process"
DevOpsDays Berlin · October 2014

[▶ Watch on Vimeo](http://vimeo.com/110484640)

### "Design Patterns in Configuration Management"
May 2014

## Volunteer

### Nashville Software School
**Mentor** · July 2014 — July 2017
EOF

echo "✓ Markdown: $OUTPUT_DIR/resume.md"

# Generate XML from YAML (simple structure)
cat > "$OUTPUT_DIR/resume.xml" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<resume>
  <name>James Fryman</name>
  <title>Engineering Leader &amp; DevOps Architect</title>
  <location>Nashville, TN</location>
  <contact>
    <email>james@fryman.io</email>
    <website>https://james.fryman.io</website>
    <github>https://github.com/jfryman</github>
    <linkedin>https://www.linkedin.com/in/jamesfryman</linkedin>
  </contact>
  <about>Engineering leader and DevOps architect who bridges the gap between technical excellence and business impact. Public speaker, author, open source contributor, and mentor based in Nashville, TN.</about>
  <experience>
    <position>
      <title>TODO: Current Role Title</title>
      <company>TODO: Company Name</company>
      <period>TODO: Date Range</period>
      <description>TODO: Description of current role</description>
    </position>
  </experience>
  <publications>
    <publication>
      <title>ChatOps for Dummies</title>
      <publisher>Wiley Publishing</publisher>
      <date>April 2015</date>
      <role>Wrote foreword and contributed</role>
    </publication>
    <publication>
      <title>Puppet Cookbook, 3rd Edition</title>
      <publisher>Packt Publishing</publisher>
      <date>February 2015</date>
      <role>Technical reviewer</role>
    </publication>
    <publication>
      <title>Puppet Reporting and Monitoring</title>
      <publisher>Packt Publishing</publisher>
      <date>June 2014</date>
      <role>Technical reviewer</role>
    </publication>
  </publications>
  <speaking>
    <talk>
      <title>ChatOps: Technology and Philosophy</title>
      <date>January 2015</date>
      <video>https://www.youtube.com/watch?v=37LmuHToYjQ</video>
    </talk>
    <talk>
      <title>DevOps: Day 2 — People and Process</title>
      <event>DevOpsDays Berlin</event>
      <date>October 2014</date>
      <video>http://vimeo.com/110484640</video>
    </talk>
    <talk>
      <title>Design Patterns in Configuration Management</title>
      <date>May 2014</date>
    </talk>
  </speaking>
  <volunteer>
    <position>
      <organization>Nashville Software School</organization>
      <role>Mentor</role>
      <period>July 2014 — July 2017</period>
    </position>
  </volunteer>
</resume>
EOF

echo "✓ XML: $OUTPUT_DIR/resume.xml"

# Generate PDF from Markdown using pandoc
if command -v pandoc &> /dev/null; then
  pandoc "$OUTPUT_DIR/resume.md" \
    -f markdown \
    -t pdf \
    --pdf-engine=xelatex \
    -V geometry:margin=1in \
    -V fontsize=11pt \
    -o "$OUTPUT_DIR/resume.pdf" 2>/dev/null || {
      echo "⚠️  PDF generation failed (xelatex not found). Install BasicTeX:"
      echo "    brew install --cask basictex"
    }
  
  if [ -f "$OUTPUT_DIR/resume.pdf" ]; then
    echo "✓ PDF: $OUTPUT_DIR/resume.pdf"
  fi
else
  echo "⚠️  pandoc not found, skipping PDF generation"
fi

echo ""
echo "Resume formats built successfully!"
echo "Files available at:"
echo "  - /resume.yaml (YAML source)"
echo "  - /resume.json (JSON)"
echo "  - /resume.xml (XML)"
echo "  - /resume.md (Markdown)"
echo "  - /resume.pdf (PDF)"
