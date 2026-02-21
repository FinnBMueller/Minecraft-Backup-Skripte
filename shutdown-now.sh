#!/bin/sh
set -e

#################################
# Konfiguration
#################################

LOCKFILE="/var/lock/minecraft-shutdown-now.lock"

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
}
trap cleanup EXIT

echo "[Backup] 🔒 Lock gesetzt"

#################################
# Minecraft Server aktion
#################################

# give 10 seconds warning
screen -S minecraft -X stuff "/say ---------- SERVER-INFO --------^M"
screen -S minecraft -X stuff "/say Manuel Server Maintenance"
screen -S minecraft -X stuff "/say Server shuts down in 10 seconds!^M"
echo "Server shuts down in 10 seconds!"
sleep 5
# give 5 seconds warning
#screen -S minecraft -X stuff "/say --------- SERVER-INFO ---------^M"
#screen -S minecraft -X stuff "/say Server shuts down in 5 seconds!^M"
#echo "Server shuts down in 5 seconds!"
sleep 2
# give 3 seconds warning
screen -S minecraft -X stuff "/say --------- SERVER-INFO ---------^M"
screen -S minecraft -X stuff "/say Server shuts down in 3 seconds!^M"
echo "Server shuts down in 3 seconds!"
sleep 1
# give 2 seconds warning
screen -S minecraft -X stuff "/say --------- SERVER-INFO ---------^M"
screen -S minecraft -X stuff "/say Server shuts down in 2 seconds!^M"
echo "Server shuts down in 2 seconds!"
sleep 1
# give 1 second warning
screen -S minecraft -X stuff "/say --------- SERVER-INFO ---------^M"
screen -S minecraft -X stuff "/say Server shuts down in 1 seconds!^M"
echo "Server shuts down in 1 sedonds!"
sleep 1
# shut down
screen -S minecraft -X stuff "/say --------- SERVER-INFO ---------^M"
screen -S minecraft -X stuff "/say Server shuts down!^M"
screen -S minecraft -X stuff "/stop^M"

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
if screen -list | grep -q "minecraft"; then
    screen -S minecraft -X quit
fi

echo ""
echo screen wurde beendet.
echo ""