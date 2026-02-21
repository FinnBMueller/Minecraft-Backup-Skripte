#!/bin/sh
set -e

#################################
# Konfiguration
#################################

LOCKFILE="/var/lock/minecraft-shutdown.lock"

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

# give 10 minute warning
screen -S minecraft -X stuff "/say --------- SERVER-INFO ---------^M"
screen -S minecraft -X stuff "/say Server shuts down in 10 minutes!^M"
echo "Server shuts down in 10 minutes!"
sleep 300
# give 5 minute warning
screen -S minecraft -X stuff "/say --------- SERVER-INFO ---------^M"
screen -S minecraft -X stuff "/say Server shuts down in 5 minutes!^M"
echo "Server shuts down in 5 minutes!"
sleep 120
# give 3 minute warning
screen -S minecraft -X stuff "/say --------- SERVER-INFO ---------^M"
screen -S minecraft -X stuff "/say Server shuts down in 3 minutes!^M"
echo "Server shuts down in 3 minutes!"
sleep 120
# give 1 minute warning
screen -S minecraft -X stuff "/say --------- SERVER-INFO ---------^M"
screen -S minecraft -X stuff "/say Server shuts down in 1 minutes!^M"
echo "Server shuts down in 1 minutes!"
sleep 30
# give 30 seconds warning
screen -S minecraft -X stuff "/say --------- SERVER-INFO ---------^M"
screen -S minecraft -X stuff "/say Server shuts down in 30 seconds!^M"
echo "Server shuts down in 30 seconds!"
sleep 20
# give 10 seconds warning
screen -S minecraft -X stuff "/say --------- SERVER-INFO ---------^M"
screen -S minecraft -X stuff "/say Server shuts down in 10 seconds!^M"
echo "Server shuts down in 10 seconds!"
sleep 1
# give 9 seconds warning
screen -S minecraft -X stuff "/say --------- SERVER-INFO ---------^M"
screen -S minecraft -X stuff "/say Server shuts down in 9 seconds!^M"
echo "Server shuts down in 9 seconds!"
sleep 1
# give 8 seconds warning
screen -S minecraft -X stuff "/say --------- SERVER-INFO ---------^M"
screen -S minecraft -X stuff "/say Server shuts down in 8 seconds!^M"
echo "Server shuts down in 8 seconds!"
sleep 1
# give 7 seconds warning
screen -S minecraft -X stuff "/say --------- SERVER-INFO ---------^M"
screen -S minecraft -X stuff "/say Server shuts down in 7 seconds!^M"
echo "Server shuts down in 7 seconds!"
sleep 1
# give 6 seconds warning
screen -S minecraft -X stuff "/say --------- SERVER-INFO ---------^M"
screen -S minecraft -X stuff "/say Server shuts down in 6 seconds!^M"
echo "Server shuts down in 6 seconds!"
sleep 1
# give 5 seconds warning
screen -S minecraft -X stuff "/say --------- SERVER-INFO ---------^M"
screen -S minecraft -X stuff "/say Server shuts down in 5 seconds!^M"
echo "Server shuts down in 5 seconds!"
sleep 1
# give 4 seconds warning
screen -S minecraft -X stuff "/say --------- SERVER-INFO ---------^M"
screen -S minecraft -X stuff "/say Server shuts down in 4 seconds!^M"
echo "Server shuts down in 4 seconds!"
sleep 1
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
echo " ----------------------------------"
echo "|>=-- Server is shutting down! --=<|"
echo " ----------------------------------"
echo ""
# Warte kurz, bis der Minecraft-Prozess wirklich beendet ist
sleep 5

# Screen-Session beenden, falls vorhanden
if screen -list | grep -q "minecraft"; then
    screen -S minecraft -X quit
fi

echo ""
echo screen wurde beendet.
echo ""