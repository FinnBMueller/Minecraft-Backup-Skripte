#!/bin/bash
set -e

#################################
# Konfiguration
#################################

LOCKFILE="/var/lock/minecraft-start.lock"

#################################
# Lockfile (Race-Condition-Schutz)
#################################

if [ -f "$LOCKFILE" ]; then
    echo "[Backup] ❌ Start läuft bereits - Abbruch."
    exit 1
fi

touch "$LOCKFILE"

cleanup() {
    rm -f "$LOCKFILE"
}
trap cleanup EXIT

echo "[Backup] 🔒 Start Lock gesetzt"

#################################
# Minecraft Server aktion
#################################

echo ""
/usr/bin/screen -ls
echo ""

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
echo " ---------------------------------" 
echo "|>=-- server has been started --=<|" 
echo " ---------------------------------" 
echo ""
/usr/bin/screen -ls
echo ""
