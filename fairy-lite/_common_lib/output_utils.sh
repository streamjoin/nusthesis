#!/usr/bin/env bash
#
# Output utilities

[[ -n "${__FAIRY_COMMON_LIB_OUTPUT_UTILS_SH__+x}" ]] && return
readonly __FAIRY_COMMON_LIB_OUTPUT_UTILS_SH__=1

readonly __FONT_NE="\033[0m"  # for reset font
readonly __FONT_BOLD="\033[1m"

readonly __BLACK="\033[30m"
readonly __RED="\033[31m"
readonly __GREEN="\033[32m"
readonly __YELLOW="\033[33m"
readonly __BLUE="\033[34m"
readonly __MAGENTA="\033[35m"
readonly __CYAN="\033[36m"
readonly __WHITE="\033[37m"

readonly __BOLD_BLACK="${__FONT_BOLD}${__BLACK}"
readonly __BOLD_RED="${__FONT_BOLD}${__RED}"
readonly __BOLD_GREEN="${__FONT_BOLD}${__GREEN}"
readonly __BOLD_YELLOW="${__FONT_BOLD}${__YELLOW}"
readonly __BOLD_BLUE="${__FONT_BOLD}${__BLUE}"
readonly __BOLD_MAGENTA="${__FONT_BOLD}${__MAGENTA}"
readonly __BOLD_CYAN="${__FONT_BOLD}${__CYAN}"
readonly __BOLD_WHITE="${__FONT_BOLD}${__WHITE}"

echo_bold_blue() {
  printf "%b%s%b\n" "${__BOLD_BLUE}" "$@" "${__FONT_NE}"
}

debug() {
  printf "[%bDEBUG%b] %b\n" "${__BOLD_YELLOW}" "${__FONT_NE}" "$@" >&1  # to stdout
}

info() {
  printf "[%bINFO%b] %b\n" "${__BOLD_BLUE}" "${__FONT_NE}" "$@" >&1  # to stdout
}

info_bold_green() {
  info "${__BOLD_GREEN}$*${__FONT_NE}"
}

info_bold_blue() {
  info "${__BOLD_BLUE}$*${__FONT_NE}"
}

warn() {
  printf "[" >&2
  printf "%b" "${__BOLD_MAGENTA}" >&1
  printf "WARNING" >&2
  printf "%b" "${__FONT_NE}" >&1
  printf "] %b\n" "$@" >&2
}

err() {
  printf "[" >&2
  printf "%b" "${__BOLD_RED}" >&1
  printf "ERROR" >&2
  printf "%b" "${__FONT_NE}" >&1
  printf "] %b\n" "$@" >&2
}

check_err() {
  local -r ec="$?"
  if [[ "${ec}" -ne 0 ]]; then
    err "$* [EXIT:${ec}]"
    exit "${ec}"
  fi
}
