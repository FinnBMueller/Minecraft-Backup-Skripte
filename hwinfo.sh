#!/bin/sh

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
# Server aktion
#################################

#starts a textbased hardware monitoring gui
htop