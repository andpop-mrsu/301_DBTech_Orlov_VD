#!/bin/bash
set -euo pipefail

# Navigate to the script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

# Generate SQL
python3 make_db_init.py

# Load into SQLite
sqlite3 movies_rating.db < db_init.sql

echo "Database movies_rating.db has been (re)initialized."


