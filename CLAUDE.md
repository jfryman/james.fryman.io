# CLAUDE.md - AI Agent Guide

This document helps AI agents (Claude, GPT, etc.) navigate and modify this codebase effectively.

## Quick Context

**What is this?** Personal website for James Fryman at https://james.fryman.io

**Tech stack:** Hugo (static site generator) + custom retro OS-themed layouts

**Key design principle:** Each page uses a different nostalgic operating system aesthetic

## Architecture Overview

### Hugo Basics (if you're unfamiliar)

Hugo is a static site generator. Key concepts:

1. **Content** (`content/`) — Markdown files become pages
2. **Layouts** (`themes/terminal/layouts/`) — HTML templates that render content
3. **Static** (`static/`) — CSS, JS, images (copied as-is)
4. **Build** (`public/`) — Generated HTML (git-ignored, deployed by CI)

### Theme Structure

We use a single custom theme called `terminal` with multiple layouts:

```
themes/terminal/layouts/
├── index.html              # Homepage (DOS/QBasic/vim theme)
├── _default/
│   ├── baseof.html        # Base template (minimal, most pages override)
│   ├── list.html          # Blog list page (Mac OS 7 theme)
│   └── single.html        # Default single page
├── resume/
│   └── single.html        # Resume page (Windows 95 Word theme)
├── contact/
│   └── single.html        # Contact page (NeXTSTEP theme)
└── projects/
    └── list.html          # Projects list (clean theme)
```

**Important:** Each layout is self-contained with its own `<style>` and `<script>` tags. They do NOT share CSS/JS files (intentional for theme isolation).

## File Locations Cheat Sheet

| What | Where |
|------|-------|
| Homepage content | `themes/terminal/layouts/index.html` (inline, not markdown) |
| Blog posts | `content/posts/*.md` |
| Resume content | `content/resume.md` |
| Contact details | `content/contact.md` |
| Projects | `content/projects/*.md` |
| Hugo config | `hugo.toml` |
| Build output | `public/` (git-ignored) |
| CI/CD | `.github/workflows/hugo.yml` |

## Common Tasks

### Add a new blog post

```bash
hugo new posts/my-post.md
# Edit content/posts/my-post.md
```

### Update contact info

1. **Contact page:** Edit `content/contact.md`
2. **Homepage dropdown:** Edit `themes/terminal/layouts/index.html` (search for `contact-dropdown`)

### Add a social link

**Three places to update:**

1. Homepage dropdown: `index.html` → `.contact-dropdown`
2. Vim commands: `index.html` → `const commands` object
3. Help menu: `index.html` → Social section in `#vim-menu`

### Update resume

1. Edit `content/resume.md` (markdown)
2. Run `scripts/generate-resume-formats.sh` to create PDF/JSON/YAML/XML versions
3. Place generated files in `static/` directory

### Change homepage theme colors

Edit CSS custom properties at top of `themes/terminal/layouts/index.html`:

```css
body[data-theme="green"] {
  --bg: #001a00;
  --text: #00ff41;
  /* ... */
}
```

## Mobile Gotchas (Important!)

### Z-Index Layering

**Rule:** Main windows should be `z-index: 100`, decorative elements lower.

- **Win95 page:** `.win95-window { z-index: 100; }`
- **Mac OS page:** `.macos-window { z-index: 100; }`
- **NeXTSTEP page:** `.nextstep-window { z-index: 100; }` + shelf lowered to `50` on mobile

### Mobile Media Queries

All themes have `@media (max-width: 768px)` adjustments. Always test mobile changes!

### Menubar Overflow

On narrow screens, menubars can push items off-screen. Solutions:
- Remove non-functional items
- Use `overflow-x: auto` with caution (breaks aesthetic)
- Simplify menu on mobile

## Development Workflow

### Local Testing

```bash
# Start dev server
hugo server --buildFuture

# Build static site
hugo --buildFuture
```

**Port:** http://localhost:1313  
**Live reload:** Yes (Hugo watches files)

### Testing Changes

1. Make edits to layouts/content
2. Check browser (auto-reloads)
3. Test on mobile (Chrome DevTools device emulation)
4. Commit + push to `main`
5. GitHub Actions deploys automatically (~2 min)

### Git Workflow

```bash
git add <files>
git commit -m "Brief description"
git push
```

**Note:** `public/` is git-ignored. Do NOT commit build output.

## Debugging Tips

### Build Fails

```bash
# Check Hugo syntax errors
hugo --buildFuture

# Common issue: unclosed {{ }} in templates
```

### Styles Not Applying

- Remember: Each layout has its own `<style>` block
- Changes to `static/css/style.css` won't affect most pages (they're self-contained)
- Check the specific layout file for that page

### Menu Not Working

- JS is inline in each layout's `<script>` tag
- Check browser console for errors
- Verify event listeners are attached correctly

## Page-Specific Notes

### Homepage (`index.html`)

- **Vim commands:** Defined in `const commands` object
- **Themes:** Toggle via Alt+T menu (stored in localStorage)
- **Menubar:** QBasic-style dropdown menus (Alt+B/P/R/C/T)
- **Status bar:** Shows only URL on mobile (simplified)

### Resume Page (`resume/single.html`)

- **Layout:** Windows 95 Word document
- **File menu:** Only functional menu (resume downloads)
- **Desktop icons:** Top-left (My Computer, Recycle Bin)
- **Start menu:** Bottom-left with navigation links

### Blog Page (`_default/list.html`)

- **Layout:** Mac OS 7 window
- **Navigation:** Clickable site title in menubar + folder icons
- **Clock:** Analog in top-right menubar

### Contact Page (`contact/single.html`)

- **Layout:** NeXTSTEP interface
- **Shelf:** Right-side dock with app icons
- **Content:** Email addresses + social links

## Common Patterns

### Adding Retro Icons

Use inline SVG data URIs for pixelated 16x16 icons:

```css
.my-icon {
  background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" fill="%23fff"><rect x="4" y="4" width="8" height="8"/></svg>') center/contain no-repeat;
  width: 16px;
  height: 16px;
  image-rendering: pixelated;
}
```

### Dropdown Menus

Pattern used across all themes:

```html
<div class="menu-item" id="my-menu">
  Label
  <div class="dropdown hidden" id="my-dropdown">
    <a href="#">Item 1</a>
  </div>
</div>

<script>
document.getElementById('my-menu').addEventListener('click', (e) => {
  e.stopPropagation();
  document.getElementById('my-dropdown').classList.toggle('hidden');
});
</script>
```

## Configuration

### Hugo Config (`hugo.toml`)

```toml
baseURL = "https://james.fryman.io/"
languageCode = "en-us"
title = "James Fryman"
theme = "terminal"

[params]
  description = "technologist · entrepreneur · hacker"
```

### GitHub Actions

**File:** `.github/workflows/hugo.yml`

**Triggers:** Push to `main`  
**Hugo version:** 0.155.3  
**Deploy target:** GitHub Pages

## External Dependencies

- **Fonts:** JetBrains Mono, Inter (via Google Fonts or system fonts)
- **Hugo:** 0.155.3+ required
- **Browser compatibility:** Modern browsers (CSS Grid, Custom Properties)

## When Making Changes

**Checklist:**

- [ ] Test in Firefox, Chrome, Safari (if available)
- [ ] Test mobile viewport (Chrome DevTools)
- [ ] Check all 4 themed pages (home, blog, resume, contact)
- [ ] Verify z-index layering on mobile
- [ ] Run `hugo --buildFuture` to check for syntax errors
- [ ] Update README.md if adding major features
- [ ] Update this file (CLAUDE.md) if architecture changes

## Handy Hugo Template Tags

```go
{{ .Title }}           - Page title
{{ .Content }}         - Rendered markdown content
{{ .Site.Title }}      - Site title from config
{{ .RelPermalink }}    - Page URL
{{ .Date }}            - Post date
{{ .WordCount }}       - Word count
{{ .ReadingTime }}     - Estimated reading time (minutes)
{{ range .Pages }}     - Loop over child pages
{{ .Summary }}         - Auto-generated excerpt
```

## Resources

- **Hugo Docs:** https://gohugo.io/documentation/
- **Live Site:** https://james.fryman.io
- **Repo:** https://github.com/jfryman/james.fryman.io

## Questions?

If you're an AI agent and something's unclear:
1. Check the actual layout file (they're self-documenting)
2. Run `hugo server` and inspect in browser
3. Look for similar patterns in other layouts
4. Ask the human (James) if you're changing architecture

---

*Last updated: 2026-02-28 by Pip (AI assistant)*
