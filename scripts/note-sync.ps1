<#
.SYNOPSIS
    Polyglot Code Learning Sync Tool
.DESCRIPTION
    Scans the current git repository, detects modified programming languages/stacks,
    and records practical coding learnings into your NotesVault.
.EXAMPLE
    cd "D:\Desktop Projects\C#Learning\EmployeeManagement"
    & "D:\Desktop Projects\NotesVault\scripts\note-sync.ps1"
#>
param (
    [string]$LearningSummary,
    [string]$ProjectName
)

$VaultRoot = if ($env:NOTES_VAULT) { $env:NOTES_VAULT } else { "D:\Desktop Projects\NotesVault" }
$Today = Get-Date -Format "yyyy-MM-dd HH:mm"

# Verify Git is available
try {
    $GitStatus = git status --porcelain 2>$null
    $LatestCommit = git log -1 --pretty=format:"%s" 2>$null
} catch {
    Write-Warning "Not in a valid Git repository or Git is not installed."
    exit
}

# Determine Project Name
if (-not $ProjectName) {
    $ProjectName = Split-Path (Get-Location) -Leaf
}

# Sniff changed files in working tree or recent commit
$ChangedFiles = git diff --name-only HEAD~1 2>$null
if (-not $ChangedFiles) {
    $ChangedFiles = git status --porcelain | ForEach-Object { $_.Substring(3) }
}

# Extension Sniffer -> Stack Mapping
$DetectedStacks = @()
$DetectedCategories = @()

foreach ($file in $ChangedFiles) {
    $ext = [System.IO.Path]::GetExtension($file).ToLower()
    $base = [System.IO.Path]::GetFileName($file).ToLower()

    switch ($ext) {
        ".cs"   { $DetectedStacks += "CSharp"; $DetectedCategories += "01_Languages\CSharp" }
        ".go"   { $DetectedStacks += "Go"; $DetectedCategories += "01_Languages\Go" }
        ".rs"   { $DetectedStacks += "Rust"; $DetectedCategories += "01_Languages\Rust" }
        ".py"   { $DetectedStacks += "Python"; $DetectedCategories += "01_Languages\Python" }
        ".ts"   { $DetectedStacks += "TypeScript"; $DetectedCategories += "01_Languages\TypeScript" }
        ".tsx"  { $DetectedStacks += "React"; $DetectedCategories += "02_Frameworks\React" }
        ".sql"  { $DetectedStacks += "PostgreSQL"; $DetectedCategories += "04_Data_Storage\PostgreSQL" }
        ".tf"   { $DetectedStacks += "Terraform"; $DetectedCategories += "03_DevOps_Cloud\Terraform" }
        default {
            if ($base -like "dockerfile*" -or $base -like "docker-compose*") {
                $DetectedStacks += "Docker"; $DetectedCategories += "03_DevOps_Cloud\Docker"
            }
        }
    }
}

$UniqueStacks = $DetectedStacks | Select-Object -Unique
if ($UniqueStacks.Count -eq 0) {
    $UniqueStacks = @("General")
}

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  Polyglot Code Session Sync" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Project: $ProjectName" -ForegroundColor Yellow
Write-Host "Detected Stacks: $($UniqueStacks -join ', ')" -ForegroundColor Yellow
if ($LatestCommit) {
    Write-Host "Latest Git Commit: $LatestCommit" -ForegroundColor DarkGray
}

if (-not $LearningSummary) {
    $LearningSummary = Read-Host "`nWhat key pattern, API, or bug fix did you learn in this session?"
    if (-not $LearningSummary -and $LatestCommit) {
        $LearningSummary = $LatestCommit
    }
}

if (-not $LearningSummary) {
    Write-Warning "No summary entered. Skipping log entry."
    exit
}

# 1. Append to Project Log
$ProjectLogDir = Join-Path $VaultRoot "06_Projects"
if (-not (Test-Path $ProjectLogDir)) { New-Item -ItemType Directory -Path $ProjectLogDir -Force | Out-Null }
$ProjectLogFile = Join-Path $ProjectLogDir "$ProjectName-Learnings.md"

if (-not (Test-Path $ProjectLogFile)) {
    $InitialHeader = "# Project Learning Log: $ProjectName`n`n| Date | Stacks | Key Learning / Pattern | Commit |`n| :--- | :--- | :--- | :--- |`n"
    Set-Content -Path $ProjectLogFile -Value $InitialHeader -Encoding UTF8
}

$CommitText = if ($LatestCommit) { $LatestCommit } else { "Working Tree" }
$LogEntry = "| $Today | $($UniqueStacks -join ', ') | $LearningSummary | $CommitText |`n"
Add-Content -Path $ProjectLogFile -Value $LogEntry -Encoding UTF8
Write-Host "[SUCCESS] Logged to Project: $ProjectLogFile" -ForegroundColor Green

# 2. Append to individual Stack logs
foreach ($stack in $UniqueStacks) {
    if ($stack -ne "General") {
        $CatMatch = $DetectedCategories | Where-Object { $_ -like "*$stack*" } | Select-Object -First 1
        if ($CatMatch) {
            $StackDir = Join-Path $VaultRoot $CatMatch
            $StackLog = Join-Path $StackDir "Practice-Log.md"
            if (-not (Test-Path $StackLog)) {
                $StackHeader = "# $stack Practice Log`n`n| Date | Project | Practical Takeaway |`n| :--- | :--- | :--- |`n"
                Set-Content -Path $StackLog -Value $StackHeader -Encoding UTF8
            }
            $StackEntry = "| $Today | $ProjectName | $LearningSummary |`n"
            Add-Content -Path $StackLog -Value $StackEntry -Encoding UTF8
            Write-Host "[SUCCESS] Updated $stack Practice Log: $StackLog" -ForegroundColor Green
        }
    }
}

Write-Host "`nAll notes updated successfully!`n" -ForegroundColor Cyan
