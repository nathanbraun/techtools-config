#!/bin/bash
tmuxsessions=$(tmux list-sessions -F "#{session_name}")

tmux_kill_session() {
    session="$1"
    if [ "$session" == "^[" ]; then
        echo "escape key pressed, not killing session"
        return
    fi
    if [[ $tmuxsessions = *"$session"* ]]; then
        tmux kill-session -t "$session"
    fi
}

choice=$(sort -rfu <<< "$tmuxsessions" \
    | fzf-tmux -p --prompt=$'\033[1A\033[2CKill\033[1B\033[2D> ' \
    | tr -d '\n') 

if [ -z "$choice" ]; then
    # echo "escape key pressed, not killing session"
    exit
else
    tmux_kill_session "$choice"
fi
