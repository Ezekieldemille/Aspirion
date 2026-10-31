# Aspirion Library homepage installer for Windows PowerShell 5.1+
# Run this script from the root of the aspirion-site project.
$ErrorActionPreference = "Stop"
$siteRoot = (Get-Location).Path
$configPath = Join-Path $siteRoot "hugo.toml"
$themeRoot = Join-Path $siteRoot "themes\aspirion"
if (-not (Test-Path -LiteralPath $configPath)) {
  throw "hugo.toml was not found. Run 'cd C:\Users\Admin\aspirion-site' first."
}
if (-not (Test-Path -LiteralPath $themeRoot)) {
  throw "The Aspirion theme was not found under themes\aspirion. Install the starter theme first."
}

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backupRoot = Join-Path $siteRoot (".aspirion-backups\" + $stamp)
$relativeFiles = @("layouts\baseof.html", "layouts\home.html", "static\css\aspirion.css")
foreach ($relative in $relativeFiles) {
  $source = Join-Path (Join-Path $PSScriptRoot "theme-files") $relative
  $dest = Join-Path $themeRoot $relative
  if (-not (Test-Path -LiteralPath $source)) { throw "Update file missing: $source" }
  if (Test-Path -LiteralPath $dest) {
    $backup = Join-Path $backupRoot $relative
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $backup) | Out-Null
    Copy-Item -LiteralPath $dest -Destination $backup -Force
  }
  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dest) | Out-Null
  Copy-Item -LiteralPath $source -Destination $dest -Force
  Write-Host "Updated $relative"
}

function New-PageIfMissing([string]$relative, [string]$body) {
  $target = Join-Path (Join-Path $siteRoot "content") $relative
  if (Test-Path -LiteralPath $target) {
    Write-Host "Kept existing content: $relative"
    return
  }
  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $target) | Out-Null
  [System.IO.File]::WriteAllText($target, $body.TrimStart(), ([System.Text.UTF8Encoding]::new($false)))
  Write-Host "Created content: $relative"
}

New-PageIfMissing "library\_index.md" @'
---
title: "The Library"
description: "The writings at the heart of Aspirion."
draft: false
---

Four collections of essays, musings, poetry, and prose.
'@
New-PageIfMissing "library\on-aspirion\_index.md" @'
---
title: "On Aspirion"
description: "Essays and reflections about Aspirion's philosophy, practices, and development."
draft: false
---
'@
New-PageIfMissing "library\in-critique\_index.md" @'
---
title: "In Critique"
description: "Critical examinations of religious doctrines, institutions, and inherited ideas."
draft: false
---
'@
New-PageIfMissing "library\in-the-world\_index.md" @'
---
title: "Aspirion in the World"
description: "Social, ethical, and political perspectives informed by Aspirionist principles."
draft: false
---
'@
New-PageIfMissing "library\poetry-and-prose\_index.md" @'
---
title: "Poetry & Prose"
description: "Poems, songs, literary reflections, and creative writing."
draft: false
---
'@
New-PageIfMissing "begin-here\_index.md" @'
---
title: "Begin Here"
description: "An introduction to Aspirion and its writings."
draft: false
---

You can begin with [the Three Paths](/three-paths/), explore [the Irreducibles](/irreducibles/), or wander into [the Library](/library/).
'@
New-PageIfMissing "about\_index.md" @'
---
title: "About Aspirion"
description: "About the developing philosophical tradition of Aspirion."
draft: false
---

Aspirion is a developing philosophical tradition expressed through essays, musings, criticism, poetry, and prose. This page can grow as its story is written.
'@

$siteConfig = Get-Content -LiteralPath $configPath -Raw
if ($siteConfig -notmatch '(?m)^\s*theme\s*=\s*["'']aspirion["'']') {
  Write-Warning "Check hugo.toml: the top-level theme should be set to 'aspirion'."
}
$rootHome = Join-Path $siteRoot "layouts\home.html"
if (Test-Path -LiteralPath $rootHome) {
  Write-Warning "Your project has layouts\home.html, which overrides the theme homepage. Back it up or rename it if the old homepage still appears."
}
Write-Host ""
Write-Host "Aspirion Library update installed. Existing content files were not overwritten."
Write-Host "Theme backups (if any): $backupRoot"
Write-Host "Start the site with: hugo server -D"
