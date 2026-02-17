#!/bin/bash
# Clear Claude status prefix (~, *, #) from window name when switching to it
name=$(tmux display-message -p '#{window_name}')
case "$name" in
  [~*#]*) tmux rename-window "${name#[~*#]}" ;;
esac
