#!/usr/bin/env bash
set -euo pipefail

#1. Define source and timestamped target
SRC="$HOME/personal"
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
DEST="$HOME/backup_archive_$TIMESTAMP"

#2. Copy the files
echo "Backing up $SRC -> $DEST"
cp -r "$SRC" "$DEST"

# 3. Prune older backups, keep only the 3 newest
cd "$HOME"
# List matching dirs sorted by newest first, skip first 3, delete the rest
to_delete=$(ls -dt backup_archive_* 2>/dev/null | tail -n +4)
if [[ -n "$to_delete" ]]; then
  echo "Removing old backups:"
  echo "$to_delete"
  xargs rm -rf <<< "$to_delete"
else
  echo "No old backups to remove."
fi

echo "Done."
