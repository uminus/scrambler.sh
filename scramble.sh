#!/bin/bash
set -eu

usage () {
  cat <<HELP_USAGE
scrambler.sh(v0.0.0) - Generates scrambles for 3x3x3

Usage: $0
  solve [experimental] With timer.
  -h    This help text.
HELP_USAGE
}

if [ "${1:-}" = "-h" ]; then
  usage
  exit 0
fi

cd "$(dirname "$0")"
LETTERS=("F" "B" "L" "R" "U" "D")
MODIFIERS=("" "'" "2")

scramble() {
  count="0"
  prev=""
  while [ $count -lt "${1:-16}" ]
  do
    letter=${LETTERS[RANDOM%${#LETTERS[@]}]}
    if [ "$letter" == "$prev" ]
    then
       continue
    fi
    modifier=${MODIFIERS[RANDOM%${#MODIFIERS[@]}]}

    echo -n "$letter$modifier "

    count=$((count + 1))
    prev=$letter
  done
}

scramble 16

if [ "${1:-}" = "solve" ]; then
  START=0

  echo
  echo "...READY..."
  echo "Hit [SPACE] to start. Then hit any key to stop it."

  read -rsn1 input
  case $input in
    "")
      START=$(date +%s%N)
      echo "!!! START !!!"
      ;;
  esac

  read -rsn1 input
  case $input in
    "2") echo "+2";;
    $'\e') echo "DNF";;
    *)
      END=$(date +%s%N)
      time=$(echo "scale=4;(${END}-${START})/1000000000" | bc)
      echo "---"
      echo "time: ${time}sec."
      ;;
  esac
fi
