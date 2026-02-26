# Resume Scripts

Scripts for managing resume data from LinkedIn and building multiple output formats.

## Quick Start

### 1. Extract LinkedIn PDF

Download your LinkedIn profile as PDF, then:

```bash
./scripts/extract-linkedin-pdf.sh ~/Downloads/Profile.pdf
```

This creates `linkedin-extracted.txt` with all the text content.

### 2. Update Resume Data

Edit `data/resume.yaml` with your extracted content. The YAML structure:

```yaml
name: Your Name
title: Your Title
email: you@example.com
phone: 555-123-4567
website: https://yoursite.com
github: https://github.com/username
linkedin: https://linkedin.com/in/username

about: >
  Your professional summary here.

skills:
  - Skill 1
  - Skill 2

experience:
  - title: "Position Title"
    company: "Company Name"
    period: "Start — End"
    location: "City, State"
    description: >
      What you did at this job.
```

### 3. Build All Formats

```bash
./scripts/build-resume-formats.sh
```

This generates:
- `static/jamesfryman-resume.yaml` (source data)
- `static/jamesfryman-resume.json` (structured)
- `static/jamesfryman-resume.xml` (structured)
- `static/jamesfryman-resume.md` (plain text)
- `static/jamesfryman-resume.pdf` (print-ready)

All formats are automatically available for download from the website at `/jamesfryman-resume.*`

## Scripts

### extract-linkedin-pdf.sh

Extracts all text from a LinkedIn PDF export.

```bash
./scripts/extract-linkedin-pdf.sh <linkedin-profile.pdf> [output.txt]
```

**Requirements:** `pdftotext` (install via `brew install poppler`)

### build-resume-formats.sh

Builds all resume output formats from `data/resume.yaml`.

```bash
./scripts/build-resume-formats.sh
```

**Requirements:** 
- `yq` for JSON conversion (install via `brew install yq`)
- `pandoc` + `xelatex` for PDF (install via `brew install pandoc` + `brew install --cask basictex`)

### linkedin-to-resume.py (Optional)

Python script that attempts to parse LinkedIn PDF into YAML structure.

```bash
./scripts/linkedin-to-resume.py <linkedin-profile.pdf> [output.yaml]
```

**Requirements:** `pip3 install PyPDF2 pyyaml`

**Note:** LinkedIn PDFs vary in format, so automatic parsing is limited. Manual editing of the YAML is usually required.

## Workflow

1. **Update from LinkedIn:**
   ```bash
   # Download LinkedIn profile as PDF
   ./scripts/extract-linkedin-pdf.sh ~/Downloads/Profile.pdf
   
   # Review the text
   cat linkedin-extracted.txt
   
   # Update data/resume.yaml manually
   vim data/resume.yaml
   ```

2. **Build all formats:**
   ```bash
   ./scripts/build-resume-formats.sh
   ```

3. **Deploy:**
   ```bash
   git add data/resume.yaml static/jamesfryman-resume.*
   git commit -m "Update resume"
   git push
   ```

## Files

- `data/resume.yaml` — Source of truth for resume data
- `content/resume.md` — Website display copy (manually kept in sync)
- `static/jamesfryman-resume.*` — Generated output formats
- `scripts/` — Build and extraction tools
