#!/bin/bash
set -e

#################################
# Konfiguration
#################################

# MCUSER="ubuntu"
BACKUPPATH="/home/ubuntu/minecraft_server_fabric_1.21.10/backups"
MAX=2 # Die Tatsächliche Anzahl an Backups ist $MAX + 1
LOCKFILE="$BACKUPPATH/.Backup-Count.lock"

#################################
# Lockfile (Race-Condition-Schutz)
#################################

if [ -f "$LOCKFILE" ]; then
    echo "[Backup-Count] ❌ Count läuft bereits - Abbruch."
    exit 1
fi

touch "$LOCKFILE"

cleanup() {
    rm -f "$LOCKFILE"
    echo "[Backup-Count] 🔓 Count Lock entfernt"
}
trap cleanup EXIT

echo "[Backup-Count] 🔒 Count Lock gesetzt"

#################################
# Backup-Count
#################################

# FOLDER=$(ls -1dt "$BACKUPPATH"/*/ 2>/dev/null)
FOLDER=$(find "$BACKUPPATH" -mindepth 1 -maxdepth 1 -type d -printf '%T@ %p\n' \
         | sort -nr | cut -d' ' -f2-)

COUNT=$(echo "$FOLDER" | wc -l)

echo ""
echo "Backup-Anzahl vor Bereinigung: $COUNT"
echo ""

if [ "$COUNT" -gt "$MAX" ]; then
    DLTARGET=$(echo "$FOLDER" | tail -n +$((MAX+1)))
    echo "[Backup-Count] 🗑 Lösche folgende Backups:"
    echo "$DLTARGET"
    rm -rf $DLTARGET
    
else
    echo "[Backup-Count] ℹ️  Keine Backups zu löschen (max. $MAX vorhanden)."
fi

FOLDER=$(find "$BACKUPPATH" -mindepth 1 -maxdepth 1 -type d -printf '%T@ %p\n' \
         | sort -nr | cut -d' ' -f2-)

COUNT=$(echo "$FOLDER" | wc -l)

echo ""
echo "Backup-Anzahl nach Bereinigung: $COUNT"
echo ""