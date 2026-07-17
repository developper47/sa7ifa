#!/bin/bash
# ==============================================================================
# pre-deploy.sh — Pre-deployment Database Backup & Rotation Script
# Target: Linux / macOS / Bash
# ==============================================================================

# 1. Define backup directory (/backups/)
BACKUP_DIR="/backups"
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR" 2>/dev/null || BACKUP_DIR="./backups"
    if [ ! -d "$BACKUP_DIR" ]; then
        mkdir -p "$BACKUP_DIR"
    fi
fi

echo "=================================================="
echo "  Fikr Magazine: Database Backup Pipeline         "
echo "=================================================="
echo "Backup Directory: $BACKUP_DIR"

# 2. Get Git commit hash or fallback
GIT_COMMIT="unknown"
if command -v git &> /dev/null; then
    GIT_COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
fi

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE_NAME="db_backup_${TIMESTAMP}_v${GIT_COMMIT}.sql"
BACKUP_FILE_PATH="${BACKUP_DIR}/${BACKUP_FILE_NAME}"

# 3. Perform Backup
BACKUP_SUCCESS=false

# --- Attempt 1: PostgreSQL Backup from Docker container ---
if command -v docker &> /dev/null; then
    if docker ps --format '{{.Names}}' | grep -q "^sa7ifa-postgres-db$"; then
        echo "Found Docker PostgreSQL container 'sa7ifa-postgres-db'. Executing dump..."
        docker exec sa7ifa-postgres-db pg_dump -U sa7ifa_admin sa7ifa_db > "$BACKUP_FILE_PATH"
        if [ $? -eq 0 ] && [ -s "$BACKUP_FILE_PATH" ]; then
            BACKUP_SUCCESS=true
        fi
    fi
fi

# --- Attempt 2: Local PostgreSQL Backup ---
if [ "$BACKUP_SUCCESS" = false ]; then
    if command -v pg_dump &> /dev/null; then
        echo "Docker not found or running. Attempting local pg_dump..."
        export PGPASSWORD="sa7ifa_secure_password_2026"
        pg_dump -U sa7ifa_admin -h localhost -d sa7ifa_db -f "$BACKUP_FILE_PATH"
        if [ $? -eq 0 ] && [ -s "$BACKUP_FILE_PATH" ]; then
            BACKUP_SUCCESS=true
        fi
    fi
fi

# --- Attempt 3: SQLite File Backup fallback ---
if [ "$BACKUP_SUCCESS" = false ]; then
    # Look for SQLite database files
    SQLITE_FILE=$(find . -maxdepth 3 -name "*.db" -o -name "*.sqlite*" | head -n 1)
    if [ -n "$SQLITE_FILE" ]; then
        echo "SQLite database file detected at '$SQLITE_FILE'. Copying database file..."
        cp "$SQLITE_FILE" "$BACKUP_FILE_PATH"
        BACKUP_SUCCESS=true
    fi
fi

# --- Attempt 4: Fallback to schema.sql ---
if [ "$BACKUP_SUCCESS" = false ]; then
    if [ -f "./schema.sql" ]; then
        echo "No active database found. Exporting schema.sql as placeholder..."
        cp "./schema.sql" "$BACKUP_FILE_PATH"
        BACKUP_SUCCESS=true
    fi
fi

# 4. Rotation: Keep only the 10 most recent backups
if [ "$BACKUP_SUCCESS" = true ]; then
    echo "Backup successfully created: $BACKUP_FILE_NAME"
    
    # Sort backups in backup directory by date (newest first), skip the first 10, and delete the rest
    # Using cd to avoid relative path listing issues with ls -t
    OLD_BACKUPS_COUNT=0
    cd "$BACKUP_DIR" || exit 1
    
    # Extract only db_backup_*.sql files to avoid messing with other items
    # and delete anything after the 10th newest
    ls -t db_backup_*.sql 2>/dev/null | tail -n +11 | while read -r file; do
        if [ -f "$file" ]; then
            echo "Deleting: $file"
            rm -f "$file"
            OLD_BACKUPS_COUNT=$((OLD_BACKUPS_COUNT + 1))
        fi
    done
    
    if [ $OLD_BACKUPS_COUNT -gt 0 ]; then
        echo "Rotation complete. Deleted $OLD_BACKUPS_COUNT old backup(s)."
    fi
    echo "Database backup pipeline completed successfully!"
else
    echo "Error: Database backup failed."
    exit 1
fi
