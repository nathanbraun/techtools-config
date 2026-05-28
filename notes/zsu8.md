---
title: tmux
date: 2024-02-21
tags: [concept, tool]
---

- terminal "multiplexer"

- normally have one terminal open, where type commands, open text editor etc
- tmux gives you more than one terminal
  - both on the same screen ("panes")
  - and with different screens ("sessions")

- normal terminal, can use [vim](hz53) etc in it

- configured in ~/.tmux.conf
- uses a [leader key](vnix), have it set to <c-space>

- one work flow:
  - always open up tmux by default - i.e. think of as part of the terminal
  - organize tmux sessions by project
  - jump between them with <tmux leader> j, s
    - have jump look for everything in [ghq](8odb) directory
  - close no longer needed sessions with <tmux leader> k

