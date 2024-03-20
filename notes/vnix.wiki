---
title: leader key
date: 2024-02-21
tags: [concept]
---

- way to do one off actions/commands in software

- easiest to understand by comparing to ctrl or shift:
  - rather than doing something (printing say) by holding down ctrl + p
  - instead would press <leader key>, let it go, *then* press p

- leader keys can vary by software

- in our setup, the keys are:
  - vim :: <space>
  - tmux :: <c-space>

- note we run vim *inside* tmux (e.g. anytime we're "in" vim, we're also "in"
  tmux, so the tmux leader key works inside vim too)
