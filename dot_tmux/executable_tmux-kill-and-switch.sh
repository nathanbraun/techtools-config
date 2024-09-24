#!/bin/bash

# Get the current session name
current_session=$(tmux display-message -p '#S')

# Get the last session name
last_session=$(tmux list-sessions | grep -v "^$current_session:" | tail -n 1 | cut -d: -f1)

# Switch to the last session
if [ -n "$last_session" ]; then
  tmux switch-client -t "$last_session"
else
  echo "No other tmux sessions are available."
  exit 1
fi

# Kill the current session
tmux kill-session -t "$current_session"
