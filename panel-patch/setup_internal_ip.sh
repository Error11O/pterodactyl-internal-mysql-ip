#!/bin/bash

# ============================
# 🛠 Pterodactyl Internal IP Setup Script (folder-based)
# ============================

# === CONFIG START ===
DB_HOST="localhost"
DB_PORT="3306"
DB_NAME="panel"
DB_USER="root"
DB_PASS="your_password"
INTERNAL_IP="172.18.0.1"
DB_HOST_ID=1
# === CONFIG END ===

set -e

echo "🔧 Checking requirements..."
command -v mysql >/dev/null || { echo >&2 "MySQL is not installed."; exit 1; }
command -v php >/dev/null || { echo >&2 "PHP is not installed."; exit 1; }
command -v yarn >/dev/null || { echo >&2 "Yarn is not installed."; exit 1; }

PATCH_DIR="./"

if [ ! -d "$PATCH_DIR" ]; then
  echo "Patch directory '$PATCH_DIR' not found. Please make sure it's in the same folder as this script."
  exit 1
fi

echo "📂 Copying patch files..."
cp "$PATCH_DIR/DatabaseTransformer.php" /var/www/pterodactyl/app/Transformers/Api/Client/DatabaseTransformer.php
cp "$PATCH_DIR/getServerDatabases.ts" /var/www/pterodactyl/resources/scripts/api/server/databases/getServerDatabases.ts
cp "$PATCH_DIR/DatabaseRow.tsx" /var/www/pterodactyl/resources/scripts/components/server/databases/DatabaseRow.tsx

echo "🛠️ Modifying database schema..."
mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" <<SQL
ALTER TABLE database_hosts ADD COLUMN IF NOT EXISTS internal_address VARCHAR(191) DEFAULT NULL;
UPDATE database_hosts SET internal_address = '$INTERNAL_IP' WHERE id = $DB_HOST_ID;
SQL

echo "Clearing Laravel cache..."
cd /var/www/pterodactyl
php artisan optimize:clear

echo "Installing dependencies and rebuilding frontend..."
yarn install --frozen-lockfile
yarn run build:production

echo "Done! Refresh your browser (CTRL+F5) to see the changes."
