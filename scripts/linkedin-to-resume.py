#!/usr/bin/env python3
"""
Extract LinkedIn PDF export and convert to resume YAML format.

Usage:
    ./linkedin-to-resume.py <linkedin-profile.pdf> [output.yaml]

Requirements:
    pip install PyPDF2 pyyaml
"""

import sys
import re
from pathlib import Path

try:
    import PyPDF2
    import yaml
except ImportError:
    print("Error: Required packages not installed")
    print("Install with: pip3 install PyPDF2 pyyaml")
    sys.exit(1)


def extract_text_from_pdf(pdf_path):
    """Extract all text from PDF file."""
    with open(pdf_path, 'rb') as f:
        reader = PyPDF2.PdfReader(f)
        text = ""
        for page in reader.pages:
            text += page.extract_text() + "\n"
    return text


def parse_contact_info(text):
    """Extract contact information from LinkedIn PDF."""
    contact = {}
    
    # Email
    email_match = re.search(r'[\w\.-]+@[\w\.-]+\.\w+', text)
    if email_match:
        contact['email'] = email_match.group(0)
    
    # Phone (various formats)
    phone_match = re.search(r'\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}', text)
    if phone_match:
        contact['phone'] = phone_match.group(0)
    
    # LinkedIn URL
    linkedin_match = re.search(r'linkedin\.com/in/([\w-]+)', text)
    if linkedin_match:
        contact['linkedin'] = f"https://www.linkedin.com/in/{linkedin_match.group(1)}"
    
    # Website (if fryman.io appears)
    if 'fryman.io' in text:
        contact['website'] = 'https://fryman.io'
    
    return contact


def extract_name(text):
    """Try to extract name from PDF (appears near top)."""
    # LinkedIn PDFs typically have name in first few lines
    lines = text.split('\n')
    for i, line in enumerate(lines[:20]):
        line = line.strip()
        # Look for a line that looks like a name (2-3 words, capitalized)
        if re.match(r'^[A-Z][a-z]+ [A-Z][a-z]+$', line):
            return line
    return "Your Name"


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)
    
    pdf_path = Path(sys.argv[1])
    output_path = Path(sys.argv[2]) if len(sys.argv) > 2 else Path('data/resume-extracted.yaml')
    
    if not pdf_path.exists():
        print(f"Error: PDF file not found: {pdf_path}")
        sys.exit(1)
    
    print(f"Extracting text from {pdf_path}...")
    text = extract_text_from_pdf(pdf_path)
    
    print("Parsing contact information...")
    contact = parse_contact_info(text)
    name = extract_name(text)
    
    # Build basic resume structure
    resume = {
        'name': name,
        'email': contact.get('email', 'your@email.com'),
        'phone': contact.get('phone', ''),
        'website': contact.get('website', ''),
        'linkedin': contact.get('linkedin', ''),
        'github': 'https://github.com/yourusername',
        'about': 'Add your professional summary here',
        'skills': [],
        'experience': [
            {
                'title': 'Position Title',
                'company': 'Company Name',
                'period': 'Start — End',
                'location': 'Location',
                'description': 'Add description here'
            }
        ]
    }
    
    # Save extracted text for manual reference
    text_path = output_path.with_suffix('.txt')
    text_path.write_text(text)
    print(f"✓ Saved raw text to: {text_path}")
    
    # Save YAML template
    output_path.write_text(yaml.dump(resume, default_flow_style=False, sort_keys=False))
    print(f"✓ Saved resume template to: {output_path}")
    
    print("\nNext steps:")
    print(f"1. Review the raw text: {text_path}")
    print(f"2. Edit the YAML template: {output_path}")
    print("3. Add your experience, skills, and education manually")
    print("4. Run: ./scripts/build-resume-formats.sh")
    print("\nNote: Automatic parsing of LinkedIn PDFs is limited.")
    print("You'll need to manually structure the experience section from the raw text.")


if __name__ == '__main__':
    main()
