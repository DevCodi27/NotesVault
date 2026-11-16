<#
.SYNOPSIS
    YouTube & Video Tutorial Capture Tool
.DESCRIPTION
    Extracts video title and transcript from a YouTube URL and generates a structured
    note in NotesVault/00_Inbox.
.EXAMPLE
    .\video-capture.ps1 -Url "https://www.youtube.com/watch?v=dQw4w9WgXcQ" -Stack "Go"
#>
param (
    [string]$Url,
    [string]$Stack
)

if (-not $Url) {
    # Check if clipboard has a YouTube link
    try {
        $Clip = Get-Clipboard -Raw -ErrorAction SilentlyContinue
        if ($Clip -match "youtu(?:\.be|be\.com)") {
            $Url = $Clip.Trim()
            Write-Host "[Auto-Detected YouTube URL from Clipboard]: $Url" -ForegroundColor Green
        }
    } catch {}
}

if (-not $Url) {
    $Url = Read-Host "Enter YouTube Video URL"
    if (-not $Url) {
        Write-Warning "URL cannot be empty. Aborted."
        exit
    }
}

if (-not $Stack) {
    $Stack = Read-Host "Enter Tech Stack (e.g. Go, Rust, CSharp, Docker, General)"
    if (-not $Stack) { $Stack = "General" }
}

$ScriptDir = Split-Path $MyInvocation.MyCommand.Path
$PyScript = Join-Path $ScriptDir "video-capture.py"

python "$PyScript" "$Url" "$Stack"
