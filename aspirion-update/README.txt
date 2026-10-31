ASPIRION: LIBRARY HOMEPAGE UPDATE
================================

Update for the custom Aspirion theme (not Ananke). Retains Old Parchment,
Wine Burgundy and Deep Walnut. Adds featured writing, four collections,
and five most recently updated pages anywhere on the website.

INSTALL
1. Stop the Hugo server with Ctrl+C.
2. Download aspirion-library-update.zip to Downloads.
3. From PowerShell:

   cd C:\Users\Admin\aspirion-site
   Expand-Archive "$env:USERPROFILE\Downloads\aspirion-library-update.zip" -DestinationPath ".\aspirion-update" -Force
   powershell -NoProfile -ExecutionPolicy Bypass -File ".\aspirion-update\INSTALL.ps1"
   hugo server -D

The installer backs up the theme files it changes in .aspirion-backups\<timestamp>.
It creates missing collection and introduction _index.md pages but NEVER
replaces existing writing. Your Ananke folder and GitHub deployment remain
unchanged.

FEATURED WRITING
Add 'featured: true' to the YAML front matter of any existing writing:

---
title: "Forward, Little Aspirist"
date: 2026-10-31
lastmod: 2026-10-31
featured: true
draft: false
---

If no featured page is marked, the homepage features the most recently
updated Library work automatically. If the Library is empty, it shows
a friendly 'Explore the Library' prompt.

RECENTLY UPDATED
The list includes the five most recently updated regular content pages
on the entire website (not just Library entries). Hugo uses 'lastmod'
from page front matter; if absent, it falls back to the page's 'date'
(or Git commit information if enabled in the site configuration).
Set 'lastmod: YYYY-MM-DD' when you make a meaningful revision so an old
piece can return to the homepage.

ADD A NEW WRITING
  hugo new content library/on-aspirion/my-first-essay.md
  hugo new content library/in-critique/critical-reflection.md
  hugo new content library/in-the-world/public-life.md
  hugo new content library/poetry-and-prose/a-poem.md

For each new page, edit the generated Markdown file, add its text, and
set draft: false when ready. No new build step is needed during preview.

EDIT HOMEPAGE SUBTITLE
If content/_index.md already exists, add the following fields inside its
front matter, not in the page body:
  hero_title: "A place to seek, to question, to become."
  subtitle: "A welcoming home for philosophy, reflection, and the practice of living well."
The theme uses the displayed defaults if those fields are absent.

If the old homepage persists, check for layouts/home.html in the project
root; those templates override themes/aspirion/layouts/home.html.
