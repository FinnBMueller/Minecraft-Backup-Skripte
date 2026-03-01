#!/bin/bash
set -e

#################################
# Konfiguration
#################################

BACKUPPATH="/home/ubuntu/minecraft_server_fabric_1.21.10/backups"
LOCKFILE="$BACKUPPATH/.MC-Start.lock"

#################################
# Lockfile (Race-Condition-Schutz)
#################################

if [ -f "$LOCKFILE" ]; then
    echo "[Start] ❌ Start läuft bereits - Abbruch."
    exit 1
fi

touch "$LOCKFILE"

cleanup() {
    rm -f "$LOCKFILE"
    echo "[Start] 🔓 Start Lock entfernt"
}
trap cleanup EXIT

echo "[Start] 🔒 Start Lock gesetzt"

#################################
# Minecraft Server aktion
#################################

# Minecraft in einer Screen-Session starten
/usr/bin/screen -dmS minecraft /usr/bin/java -Xmx20G -jar fabric-server-mc.1.21.10-loader.0.17.3-launcher.1.1.0.jar nogui

echo ""
echo "Process starting"
sleep 1
echo "5"
sleep 1
echo "4"
sleep 1
echo "3"
sleep 1
echo "2"
sleep 1
echo "1"
echo "" 
if screen -ls | grep -q "[0-9]\+\."; then
    echo " ---------------------------------" 
    echo "|>=-- server has been started --=<|" 
    echo " ---------------------------------" 
    echo ""
    /usr/bin/screen -ls
else
    echo "[Backup] ⚠️ Kein laufender Screen gefunden - Serverstart nicht bestätigt."
fi
echo ""
