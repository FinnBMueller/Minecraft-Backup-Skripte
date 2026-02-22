#!/bin/bash
set -e

#################################
# Konfiguration
#################################

LOCKFILE="/var/lock/minecraft-shutdown-now.lock"

#################################
# Lockfile (Race-Condition-Schutz)
#################################

if [ -f "$LOCKFILE" ]; then
    echo "[Backup] ❌ Shutdown-Now läuft bereits - Abbruch."
    exit 1
fi

touch "$LOCKFILE"

cleanup() {
    rm -f "$LOCKFILE"
}
trap cleanup EXIT

echo "[Backup] 🔒 Shutdown-Now Lock gesetzt"

#################################
# Minecraft Server aktion
#################################

echo ""
/usr/bin/screen -ls
echo ""

# give 10 seconds warning
/usr/bin/screen -S minecraft -X stuff "/say ---------- SERVER-INFO --------^M"
/usr/bin/screen -S minecraft -X stuff "/say manuelle Server Maintenance"
/usr/bin/screen -S minecraft -X stuff "/say Server shuts down in 10 seconds!^M"
echo "Server shuts down in 10 seconds!"
sleep 5
# give 5 seconds warning
/usr/bin/screen -S minecraft -X stuff "/say --------- SERVER-INFO ---------^M"
/usr/bin/screen -S minecraft -X stuff "/say Server shuts down in 5 seconds!^M"
echo "Server shuts down in 5 seconds!"
sleep 1
# give 4 seconds warning
/usr/bin/screen -S minecraft -X stuff "/say --------- SERVER-INFO ---------^M"
/usr/bin/screen -S minecraft -X stuff "/say Server shuts down in 4 seconds!^M"
echo "Server shuts down in 5 seconds!"
sleep 1
# give 3 seconds warning
/usr/bin/screen -S minecraft -X stuff "/say --------- SERVER-INFO ---------^M"
/usr/bin/screen -S minecraft -X stuff "/say Server shuts down in 3 seconds!^M"
echo "Server shuts down in 3 seconds!"
sleep 1
# give 2 seconds warning
/usr/bin/screen -S minecraft -X stuff "/say --------- SERVER-INFO ---------^M"
/usr/bin/screen -S minecraft -X stuff "/say Server shuts down in 2 seconds!^M"
echo "Server shuts down in 2 seconds!"
sleep 1
# give 1 second warning
/usr/bin/screen -S minecraft -X stuff "/say --------- SERVER-INFO ---------^M"
/usr/bin/screen -S minecraft -X stuff "/say Server shuts down in 1 seconds!^M"
echo "Server shuts down in 1 sedonds!"
sleep 1
# shut down
/usr/bin/screen -S minecraft -X stuff "/say --------- SERVER-INFO ---------^M"
/usr/bin/screen -S minecraft -X stuff "/say Server shuts down!^M"
/usr/bin/screen -S minecraft -X stuff "/stop^M"

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
sleep 1
echo ""
echo " ----------------------------------"
echo "|>=-- server has been shutdown --=<|"
echo " ----------------------------------"
echo ""

# Screen-Session beenden, falls vorhanden
if /usr/bin/screen -list | grep -q "minecraft"; then
    /usr/bin/screen -S minecraft -X quit
fi

echo ""
/usr/bin/screen -ls
echo ""
