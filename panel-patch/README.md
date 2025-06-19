# Pterodactyl Internal MySQL IP Patch

## ❗ Important

**Before running this patch, make sure that a MySQL host is already added in the Pterodactyl panel under `Admin > Databases > Database Hosts`.**  
If no host exists, the internal IP field (`internal_address`) will not be set.

This repository provides a patch and setup script to display the **internal MySQL IP address** (e.g., `172.18.0.1`) in the Pterodactyl panel — ideal for game servers running in Docker containers that need to connect directly to the MySQL service on the host.

---

## Contents

- `setup_internal_ip.sh` – Fully automated setup script
- `DatabaseTransformer.php` – Backend API patch to expose `internal_address`
- `getServerDatabases.ts` – Client-side API parser update
- `DatabaseRow.tsx` – UI modification to display internal IP in the panel

---

## Installation

1. Clone this repository or download the ZIP:

```bash
git clone https://github.com/your-username/pterodactyl-internal-mysql-ip.git
cd pterodactyl-internal-mysql-ip
```

2. Make the setup script executable:

```bash
chmod +x setup_internal_ip.sh
```

3. Open `setup_internal_ip.sh` and configure:

- `DB_USER`, `DB_PASS`, `DB_NAME` = your MySQL root user and Pterodactyl panel DB
- `INTERNAL_IP` = your Docker bridge IP (e.g., `172.18.0.1`)
- `DB_HOST_ID` = ID of the MySQL host entry inside the `database_hosts` table

4. Run the script:

```bash
sudo ./setup_internal_ip.sh
```

---

## What the Script Does

- Extracts and installs patched files for backend and frontend
- Adds `internal_address` column to `database_hosts` table if not present
- Updates that value with the IP you set
- Clears Laravel config, cache, view, and route cache
- Runs the official Pterodactyl frontend build via `yarn`

---

## Result

In your server dashboard under the database section, the **Endpoint** will now show something like:

```
172.18.0.1:3306
```

This allows game servers (in Docker) to directly connect to MySQL on the host system without DNS or public IPs.

---

## Disclaimer

- This is a customization and is **not officially supported by the Pterodactyl team**
- Backup your files before applying

---

## License

MIT
