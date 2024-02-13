#!/bin/bash

# Set the user's home directory and backup directory
HOME_DIR="$HOME"
BACKUP_ROOT="$HOME/config_backup"

# List of config files and directories to backup or restore
CONFIG_FILES_LIST=(
  ".config"
  ".inputrc"
  ".p10k.zsh"
  ".tmux"
  ".tmux.conf"
  ".tmux.conf.local"
  ".zlogin"
  ".zlogout"
  ".zpreztorc"
  ".zprofile"
  ".zshev"
  ".zshrc"
)

# Function to create a timestamped backup directory
create_backup_dir() {
  local timestamp=$(date +%Y%m%d_%H%M%S)
  BACKUP_DIR="$BACKUP_ROOT/$timestamp"
  mkdir -p "$BACKUP_DIR"
}

# Function to backup config files and directories
backup() {
  # Create the timestamped backup directory
  create_backup_dir

  for item in "${CONFIG_FILES_LIST[@]}"; do
    if [ -e "$HOME_DIR/$item" ]; then
      mv -v "$HOME_DIR/$item" "$BACKUP_DIR"
    fi
  done

  echo "Config files and directories backup completed. Backup is stored in $BACKUP_DIR"
}

# Function to restore config files and directories from the backup directory
restore() {
  if [ -d "$BACKUP_ROOT" ]; then
    # Get the latest backup directory
    BACKUP_DIR=$(ls -td -- "$BACKUP_ROOT"/*/ | head -n 1)

    if [ -z "$BACKUP_DIR" ]; then
      echo "No backup found in $BACKUP_ROOT. Cannot restore."
      exit 1
    fi

    for item in "${CONFIG_FILES_LIST[@]}"; do
      if [ -e "$BACKUP_DIR/$item" ]; then
        mv -v "$BACKUP_DIR/$item" "$HOME_DIR"
      fi
    done

    echo "Config files and directories restored from $BACKUP_DIR"
  else
    echo "Backup root directory $BACKUP_ROOT not found. Cannot restore."
  fi
}

# Check command line arguments
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 {backup|restore}"
  exit 1
fi

if [ "$1" = "backup" ]; then
  backup
elif [ "$1" = "restore" ]; then
  restore
else
  echo "Invalid option. Usage: $0 {backup|restore}"
  exit 1
fi
