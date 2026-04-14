#!/usr/bin/env bash

append_if_missing() {
  local file="$1" marker="$2" block="$3" msg_added="$4" msg_exists="$5"
  if ! grep -qF "$marker" "$file"; then
    printf '\n%s\n' "$block" >> "$file"
    echo "› $msg_added"
  else
    echo "› $msg_exists"
  fi
}
