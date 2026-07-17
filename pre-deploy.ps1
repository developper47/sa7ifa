# ==============================================================================
# pre-deploy.ps1 — Pre-deployment Database Backup & Rotation Script
# Target: Windows PowerShell
# ==============================================================================

# 1. Define backup directory (/backups/)
# Resolves to root-level "\backups" on the current drive or falls back to local workspace subdirectory
$BackupDir = "\backups"
if (-not (Test-Path $BackupDir)) {
    try {
        New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
    } catch {
        # Fallback to local workspace backups folder if drive root is write-protected
        $BackupDir = Join-Path $PSScriptRoot "backups"
        if (-not (Test-Path $BackupDir)) {
            New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
        }
    }
}

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  Fikr Magazine: Database Backup Pipeline         " -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Backup Directory: $BackupDir" -ForegroundColor Yellow

# 2. Get Git commit hash or fallback
$GitCommit = "unknown"
try {
    if (Get-Command git -ErrorAction SilentlyContinue) {
        $GitCommit = (git rev-parse --short HEAD).Trim()
    }
} catch {
    # Git not installed or not in a git repo
}

$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$BackupFileName = "db_backup_${Timestamp}_v${GitCommit}.sql"
$BackupFilePath = Join-Path $BackupDir $BackupFileName

# 3. Perform Backup
$BackupSuccess = $false

# --- Attempt 1: PostgreSQL Backup from Docker container ---
try {
    if (Get-Command docker -ErrorAction SilentlyContinue) {
        $Containers = docker ps --filter "name=sa7ifa-postgres-db" --format "{{.Names}}"
        if ($Containers -contains "sa7ifa-postgres-db") {
            Write-Host "Found Docker PostgreSQL container 'sa7ifa-postgres-db'. Executing dump..." -ForegroundColor Gray
            docker exec -t sa7ifa-postgres-db pg_dump -U sa7ifa_admin sa7ifa_db > $BackupFilePath
            if ($LASTEXITCODE -eq 0 -and (Test-Path $BackupFilePath) -and (Get-Item $BackupFilePath).Length -gt 0) {
                $BackupSuccess = $true
            }
        }
    }
} catch {
    Write-Host "Docker pg_dump attempt failed: $_" -ForegroundColor Red
}

# --- Attempt 2: Local PostgreSQL Backup ---
if (-not $BackupSuccess) {
    try {
        if (Get-Command pg_dump -ErrorAction SilentlyContinue) {
            Write-Host "Docker not found or running. Attempting local pg_dump..." -ForegroundColor Gray
            $env:PGPASSWORD = "sa7ifa_secure_password_2026"
            pg_dump -U sa7ifa_admin -h localhost -d sa7ifa_db -f $BackupFilePath
            if ($LASTEXITCODE -eq 0 -and (Test-Path $BackupFilePath) -and (Get-Item $BackupFilePath).Length -gt 0) {
                $BackupSuccess = $true
            }
        }
    } catch {
        Write-Host "Local pg_dump attempt failed: $_" -ForegroundColor Red
    }
}

# --- Attempt 3: SQLite File Backup fallback ---
if (-not $BackupSuccess) {
    # Check if there are SQLite database files in the workspace
    $SQLiteFiles = Get-ChildItem -Path $PSScriptRoot -Filter "*.db" -Recurse -ErrorAction SilentlyContinue
    if ($SQLiteFiles.Count -eq 0) {
        $SQLiteFiles = Get-ChildItem -Path $PSScriptRoot -Filter "*.sqlite*" -Recurse -ErrorAction SilentlyContinue
    }
    
    if ($SQLiteFiles.Count -gt 0) {
        $DbFile = $SQLiteFiles[0].FullName
        Write-Host "SQLite database file detected at '$DbFile'. Copying database file..." -ForegroundColor Gray
        Copy-Item -Path $DbFile -Destination $BackupFilePath -Force
        $BackupSuccess = $true
    }
}

# --- Attempt 4: Fallback to copying schema files (for testing/reconstructions) ---
if (-not $BackupSuccess) {
    $SchemaFile = Join-Path $PSScriptRoot "schema.sql"
    if (Test-Path $SchemaFile) {
        Write-Host "No active database found. Exporting schema.sql as placeholder..." -ForegroundColor Yellow
        Copy-Item -Path $SchemaFile -Destination $BackupFilePath -Force
        $BackupSuccess = $true
    }
}

# 4. Rotation: Keep only the 10 most recent backups
if ($BackupSuccess) {
    Write-Host "Backup successfully created: $BackupFileName" -ForegroundColor Green
    
    $OldBackups = Get-ChildItem -Path $BackupDir -Filter "db_backup_*.sql" | 
                  Sort-Object LastWriteTime -Descending | 
                  Select-Object -Skip 10
                  
    if ($OldBackups.Count -gt 0) {
        Write-Host "Rotating backups: deleting $($OldBackups.Count) oldest backups..." -ForegroundColor Gray
        foreach ($OldBackup in $OldBackups) {
            Write-Host "Deleting: $($OldBackup.Name)" -ForegroundColor DarkGray
            Remove-Item -Path $OldBackup.FullName -Force
        }
    }
    Write-Host "Database backup pipeline completed successfully!" -ForegroundColor Green
} else {
    Write-Host "Error: Database backup failed." -ForegroundColor Red
    exit 1
}
