# Internal MySQL Networking for Pterodactyl Wings

This guide helps you configure internal MySQL access for game servers running inside Docker containers, using the Pterodactyl panel and a host-based MySQL instance.

## 🧠 Overview

This setup allows the game server containers to access the MySQL server on the Docker host using the internal Docker bridge IP (e.g. `172.18.0.1`). This internal IP is shown in the panel so that games can use it directly.

## 📁 Structure

This repository is split into two main folders:

- `node-patch/`: Includes a script to expose the host MySQL to Docker containers (iptables & UFW setup).
- `panel-patch/`: Contains scripts and files to patch the Pterodactyl panel so it shows the internal IP address to the user.

## ⚙️ Usage

### 1. Expose MySQL to Docker Containers

Go into the `node-patch` directory and run the script:

```bash
cd node-patch
sudo bash setup_ptero_mysql_network.sh
```

This will:
- Detect the internal Docker IP (gateway)
- Set UFW rules
- Add iptables NAT rules
- Save the configuration

### 2. Patch the Panel to Display Internal IP

Go into the `panel-patch` directory and edit the script to configure your database connection:

```bash
cd panel-patch
nano setup_internal_ip_patch_folder_en.sh
```

Then run it:

```bash
sudo bash setup_internal_ip_patch.sh
```

This will:
- Add an `internal_address` column to the `database_hosts` table
- Set it to your internal Docker IP (e.g. `172.18.0.1`)
- Replace frontend/backend files to show internal IPs
- Rebuild the frontend with `yarn`

### 3. Refresh the Panel

Use `CTRL + F5` in your browser to clear cache and load the new UI. Now, when creating or viewing a database in the panel, you’ll see the internal Docker IP instead of the external IP.

## ✅ Requirements

- Docker and Docker network `pterodactyl_nw` created
- MySQL server running on the host
- Pterodactyl panel already installed
- `yarn`, `php`, `mysql-client`, `iptables`, and `ufw` installed

## 💬 Notes

- Tested with Pterodactyl v1.11+
- Backup your files before applying patches
- If the panel doesn’t show the internal IP, ensure you cleared the cache and ran `yarn build:production`

## 📎 Credits

This patch and automation was created to support better Docker-native MySQL connectivity with Pterodactyl.

---

Enjoy your faster and more secure internal database connections!