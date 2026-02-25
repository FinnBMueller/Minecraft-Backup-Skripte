#!/bin/bash
set -e

#################################
# Konfiguration
#################################

MCUSER="ubuntu"
MCPATH="/home/ubuntu/minecraft_server_fabric_1.21.10"
BACKUPPATH="/home/ubuntu/minecraft_server_fabric_1.21.10/backups"
LOCKFILE="/var/lock/minecraft-backup.lock"

# Datum im Format: tag-monat-jahr__stunde-minute
TIMESTAMP=$(date +"%Y-%m-%d__%H-%M")

#################################
# Lockfile (Race-Condition-Schutz)
#################################

if [ -f "$LOCKFILE" ]; then
    echo "[Backup] ❌ Backup läuft bereits - Abbruch."
    exit 1
fi

touch "$LOCKFILE"

cleanup() {
    rm -f "$LOCKFILE"
    echo "[Backup] 🔓 Backup Lock entfernt"
}
trap cleanup EXIT

echo "[Backup] 🔒 Backup Lock gesetzt"

#################################
# Minecraft Server Shutdown
#################################

echo "[Backup] 🛑 Prüfe, ob ein Screen läuft..."

if sudo -u "$MCUSER" screen -ls | grep -q "[0-9]\+\."; then
    echo "[Backup] 🛑 Screen gefunden - Minecraft wird heruntergefahren..."
    sudo -u "$MCUSER" bash "$MCPATH/shutdown.sh"
    sleep 5
else
    echo "[Backup] ⚠️ Kein laufender Screen gefunden - Shutdown wird übersprungen."
fi

#################################
# Backup Anzahl überprüfen
#################################

echo "[Backup] 🛑 Backup-Anzahl wird überprüft..."
sudo -u "$MCUSER" bash "$MCPATH/backup-count.sh"

echo "[Backup] ✅ Backup-Anzahl wurde überprüft"

#################################
# Backup erstellen
#################################

echo "[Backup] 📦 Erstelle Backup..."
sudo -u "$MCUSER" mkdir -p "$BACKUPPATH"
sudo -u "$MCUSER" cp -r "$MCPATH/world" "$BACKUPPATH/world__$TIMESTAMP"

echo "[Backup] ✅ Backup abgeschlossen: world__$TIMESTAMP"

#################################
# Minecraft Server neu starten
#################################

echo "[Backup] ▶ Starte Minecraft Server..."

sudo -u "$MCUSER" bash "$MCPATH/start.sh"

echo "[Backup] 🟢 Fertig!"
echo""
