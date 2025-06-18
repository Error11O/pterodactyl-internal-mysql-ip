
# 🔧 setup_ptero_mysql_network_custom.sh

This script configures the network setup for a Pterodactyl panel to allow Docker-based game server containers to connect to a MySQL database on the host machine via an **internal IP** (e.g., `172.18.0.1`).

---

## 📋 What This Script Does

1. 🔍 Detects the Docker network (e.g., `pterodactyl_nw`)
2. 🛠 Adds or updates the internal IP alias (e.g., `172.18.0.1`) for MySQL in the database
3. 🐘 Updates the `database_hosts` table used by Pterodactyl
4. 🔁 Clears Laravel caches (`php artisan config:clear`, etc.)
5. 🧪 Optionally tests internal MySQL connectivity

---

## 🛠️ Usage

### 🔽 1. Download the Script

```bash
wget https://your-domain.com/setup_ptero_mysql_network_custom.sh
chmod +x setup_ptero_mysql_network_custom.sh
```

### ⚙️ 2. Configure Your Settings

Edit the following variables at the top of the script:

```bash
# ==== Configuration ====
INTERNAL_IP="172.18.0.1"       # Internal Docker bridge IP
DB_ID=1                        # ID from the 'database_hosts' table
DB_NAME="panel"                # Name of your Pterodactyl panel database
DB_USER="root"                 # MySQL user
DB_PASS="your-password"        # MySQL password
```

### ▶️ 3. Run the Script

```bash
sudo ./setup_ptero_mysql_network_custom.sh
```

---

## ✅ Result

The Pterodactyl panel will now display the **internal IP** (e.g., `172.18.0.1:3306`) as the **endpoint** when creating new databases for servers. This allows containers to connect directly without using external IPs or NAT.

---

## ❗ Important Notes

- This script **modifies** the Pterodactyl database directly.
- Always make a **backup** before running.
- Make sure the Docker network exists and matches the IP you're configuring.

---

## 📜 License

MIT – Use at your own risk.
