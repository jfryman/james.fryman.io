# james.fryman.io

Personal website for James Fryman — built with [Hugo](https://gohugo.io/) and featuring multiple retro OS-themed layouts.

## Overview

A modern personal website with a nostalgic twist. Each page uses a different retro operating system theme:

- **Homepage**: DOS/QBasic-style terminal with vim keybindings (`:help` for commands)
- **Blog** (`/posts/`): Mac OS 7 window with folder navigation
- **Resume** (`/resume/`): Windows 95 Word document aesthetic
- **Contact** (`/contact/`): NeXTSTEP interface with dock/shelf
- **Projects** (`/projects/`): Clean list view

## Features

### Homepage (DOS/QBasic Theme)
- Interactive vim-style command line (`:blog`, `:resume`, `:github`, etc.)
- QBasic-inspired menubar with keyboard shortcuts (Alt+Letter)
- Theme switcher (Green Screen, QBasic, Solarized Dark/Light)
- Social links dropdown with pixelated retro icons

### Resume Page (Windows 95 Theme)
- Word 95 document interface
- Functional File menu with resume downloads (PDF, Markdown, YAML, JSON, XML)
- Desktop icons and Start menu navigation
- Live clock in taskbar

### Blog Page (Mac OS 7 Theme)
- Mac OS 7 window with title bar
- Clickable site title in menubar for navigation
- Folder icons for navigation (desktop mode)
- Analog clock in top-right

### Contact Page (NeXTSTEP Theme)
- NeXTSTEP window with dock/shelf
- Analog clock in shelf
- Email (personal + business)
- Social links: GitHub, LinkedIn, Bluesky, Mastodon, Instagram, X/Twitter
- Side hustle link: Fitz Prints

## Local Development

```bash
# Install Hugo (macOS)
brew install hugo

# Start development server
hugo server --buildFuture

# Or with drafts
hugo server -D
```

Then open http://localhost:1313

## Project Structure

```
.
├── content/              # Markdown content files
│   ├── posts/           # Blog posts
│   ├── projects/        # Projects
│   ├── resume.md        # Resume content
│   └── contact.md       # Contact details
├── themes/terminal/     # Custom theme
│   └── layouts/
│       ├── index.html                  # Homepage (DOS/vim)
│       ├── _default/
│       │   └── list.html              # Blog list (Mac OS 7)
│       ├── resume/
│       │   └── single.html            # Resume (Windows 95)
│       └── contact/
│           └── single.html            # Contact (NeXTSTEP)
├── static/              # Static assets
│   ├── css/
│   └── js/
└── hugo.toml           # Hugo configuration

```

## Deployment

GitHub Actions automatically builds and deploys to GitHub Pages on push to `main`.

**Workflow:** `.github/workflows/hugo.yml`

## Customization

### Adding Content

```bash
# New blog post
hugo new posts/my-post.md

# New project
hugo new projects/my-project.md
```

### Updating Contact Info

Edit `content/contact.md` for the NeXTSTEP contact page.

Homepage contact dropdown is in `themes/terminal/layouts/index.html` (search for `contact-dropdown`).

### Theme Colors

Homepage themes are defined in CSS custom properties at the top of `themes/terminal/layouts/index.html`.

### Resume Downloads

Resume formats are auto-generated from `content/resume.md` via scripts in `scripts/` directory.

## Mobile Optimizations

All themes are mobile-responsive with:
- Adjusted z-index for proper layering
- Simplified menubars on narrow screens
- Touch-friendly navigation
- Optimized icon sizes

## Contact

- **Personal**: james@fryman.io
- **Business**: james@frykinindustries.com
- **GitHub**: [@jfryman](https://github.com/jfryman)
- **LinkedIn**: [jamesfryman](https://www.linkedin.com/in/jamesfryman/)

## License

Content © James Fryman. Code for educational purposes.
