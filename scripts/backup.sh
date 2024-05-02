#!/bin/bash

# Load environment variables from .env file
source "$(dirname "$0")/../.env"

# Create the backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Perform the database backup
pg_dump -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -F p -f "$BACKUP_DIR/$BACKUP_FILE"

# Check if the backup was successful
if [ $? -eq 0 ]; then
    echo "Database backup created successfully: $BACKUP_DIR/$BACKUP_FILE"
else
    echo "Database backup failed"
    exit 1
fi
