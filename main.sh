#!/usr/bin/env bash

run_commands_main() {
  local APP="$1"
  local IMG="dokku/$APP"
  local LST="/home/dokku/${APP}/run-commands"

  if [ -f "$LST" ] ; then
    echo "-----> running commands from ${LST}..."

    while read -rd $'\0' line ; do
      echo "-----> running command"
      echo "       ${line}"

      id=$(docker run -i -a stdin "$IMG" /bin/bash -e -c "$line")

      test "$(docker wait "$id")" -eq 0
      docker commit "$id" "$IMG" > /dev/null
    done < "$LST"
  fi
}