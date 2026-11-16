<#
.SYNOPSIS
    Web Documentation & Article Ingestion Tool
.DESCRIPTION
    Scrapes an official docs page, blog, or article, strips HTML boilerplate,
    and generates a structured technical note in NotesVault/00_Inbox.
.EXAMPLE
    .\web-capture.ps1 -Url "https://go.dev/doc/effective_go" -Stack "Go"
#>
param (
    [string]$Url,
    [string]$Stack
)

$VaultRoot = if ($env:NOTES_VAULT) { $env:NOTES_VAULT } else { "D:\Desktop Projects\NotesVault" }
$InboxDir = Join-Path $VaultRoot "00_Inbox"
$Today = Get-Date -Format "yyyy-MM-dd"

if (-not $Url) {
    try {
        $Clip = Get-Clipboard -Raw -ErrorAction SilentlyContinue
        if ($Clip -match "^https?://") {
            $Url = $Clip.Trim()
            Write-Host "[Auto-Detected Web URL from Clipboard]: $Url" -ForegroundColor Green
        }
    } catch {}
}

if (-not $Url) {
    $Url = Read-Host "Enter Documentation / Article URL"
    if (-not $Url) {
        Write-Warning "URL cannot be empty. Aborted."
        exit
    }
}

if (-not $Stack) {
    $Stack = Read-Host "Enter Tech Stack (e.g. CSharp, Go, Rust, React, Docker, General)"
    if (-not $Stack) { $Stack = "General" }
}

Write-Host "Fetching web content from: $Url..." -ForegroundColor Cyan

try {
    $Response = Invoke-WebRequest -Uri $Url -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" -UseBasicParsing -TimeoutSec 10
    $Html = $Response.Content

    # Extract Title
    $Title = "Web Article"
    if ($Html -match "<title[^>]*>(.*?)</title>") {
        $Title = $Matches[1] -replace '\s+', ' ' -replace '[\\/*?:"<>|]', ''
        $Title = $Title.Trim()
    }

    # Clean Slug
    $Slug = ($Title -replace '[^\w\s-]', '' -replace '\s+', '-').Trim()
    if ($Slug.Length -gt 50) { $Slug = $Slug.Substring(0, 50) }
    $OutFile = Join-Path $InboxDir "web-$Slug.md"

    # Strip HTML tags for clean text preview
    $TextContent = $Html -replace '<script[^>]*>[\s\S]*?</script>', ''
    $TextContent = $TextContent -replace '<style[^>]*>[\s\S]*?</style>', ''
    $TextContent = $TextContent -replace '<[^>]+>', ' '
    $TextContent = [System.Net.WebUtility]::HtmlDecode($TextContent) -replace '\s+', ' '
    $PreviewText = if ($TextContent.Length -gt 1500) { $TextContent.Substring(0, 1500) + "..." } else { $TextContent }
    $CodeFence = "```" + $Stack.ToLower()
    $EndFence = "```"

    $NoteContent = "---`n" +
        "topic: `"$Title`"`n" +
        "stack: `"$Stack`"`n" +
        "category: `"Web_Documentation`"`n" +
        "tags: [`"$($Stack.ToLower())`", `"documentation`", `"web-notes`"]`n" +
        "source_type: `"Documentation`"`n" +
        "source_ref: `"$Url`"`n" +
        "date: $Today`n" +
        "status: `"seeded`"`n" +
        "---`n`n" +
        "# 🌐 Documentation Notes: $Title`n`n" +
        "- **Source URL**: [$Url]($Url)`n" +
        "- **Captured Date**: $Today`n" +
        "- **Assigned Stack**: $Stack`n`n" +
        "---`n`n" +
        "## 1. Mental Model & Architecture Takeaway`n" +
        "<!-- What core problem does this technology or API solve? -->`n`n" +
        "## 2. Core Code Syntax & Configurations`n" +
        "$CodeFence`n" +
        "// Key snippets, signatures, or configuration manifests`n" +
        "$EndFence`n`n" +
        "## 3. Important Rules, Limits & Gotchas`n" +
        "- ⚠️ `n`n" +
        "## 4. Quick API / Syntax Reference`n" +
        "| Method / Directive | Description | Example |`n" +
        "| :--- | :--- | :--- |`n`n" +
        "## 5. Raw Excerpt / Overview`n" +
        "> $PreviewText`n"

    if (-not (Test-Path $InboxDir)) { New-Item -ItemType Directory -Path $InboxDir -Force | Out-Null }
    Set-Content -Path $OutFile -Value $NoteContent -Encoding UTF8

    Write-Host "`n[SUCCESS] Web article note created at:" -ForegroundColor Green
    Write-Host "  $OutFile" -ForegroundColor Cyan
} catch {
    Write-Error "Failed to fetch URL. Error: $_"
}
