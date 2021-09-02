#!/bin/sh

set -eu

DEPCHECK_VERBOSE=${DEPCHECK_VERBOSE:-0}

DEPCHECK_SPLIT=${DEPCHECK_SPLIT:-0}

usage() {
  # This uses the comments behind the options to show the help. Not extremly
  # correct, but effective and simple.
  echo "$0 check binaries in args are accessible at the PATH, options:" && \
    grep "[[:space:]].)\ #" "$0" |
    sed 's/#//' |
    sed -r 's/([a-z])\)/-\1/'
  exit "${1:-0}"
}

while getopts "svh-" opt; do
  case "$opt" in
    v) # Turn on verbosity
      DEPCHECK_VERBOSE=1;;
    h) # Print help and exit
      usage;;
    s) # Split on whitespaces inside arguments as well (for actions compat.)
      DEPCHECK_SPLIT=1;;
    -)
      break;;
    *)
      usage 1;;
  esac
done
shift $((OPTIND-1))


_verbose() {
  [ "$DEPCHECK_VERBOSE" = "1" ] && printf %s\\n "$1" >&2 || true
}

_error() {
  printf %s\\n "$1" >&2
  exit 1
}

_bincheck() {
  if [ -n "$1" ]; then
    if command -v "$1" >/dev/null 2>&1; then
      _verbose "$1 is accessible as $(command -v "$1" 2>/dev/null)"
    else
      _error "$1 not found in path: $PATH"
    fi
  fi
}

if [ "$DEPCHECK_SPLIT" = "0" ]; then
  for bin in "$@"; do
    _bincheck "$bin"
  done
else
  # shellcheck disable=SC2048 # On purpose! We could write $1 but $* is more generic.
  for bin in $*; do
    _bincheck "$bin"
  done
fi