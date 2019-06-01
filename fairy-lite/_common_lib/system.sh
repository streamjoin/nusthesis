#!/usr/bin/env bash
#
# Operating system related utilities.

[[ -n "${__FAIRY_COMMON_LIB_SYSTEM_SH__+x}" ]] && return
readonly __FAIRY_COMMON_LIB_SYSTEM_SH__=1

# Include dependencies
[[ -n "${FAIRY_HOME+x}" ]] || readonly FAIRY_HOME="$(cd "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)/.."
# shellcheck disable=SC1090
source "${FAIRY_HOME}/_common_lib/output_utils.sh"

check_cmd_exists() {
  [[ "$#" -gt 0 ]] && [[ "$#" -le 2 ]]
  check_err "wrong number of parameters to 'check_cmd_exists()'"
  
  command -v "$1" >/dev/null ||
  check_err "command ${1:+"'$1'"} not found${2:+": $2"}"
}

check_cmd_args() {
  local -r EXIT_CODE="$?"
  if [[ "${EXIT_CODE}" -ne 0 ]]; then
    err "Usage: $(basename -- "$0") $*"
    exit "${EXIT_CODE}"
  fi
}

os_type() {
  local -r kern_name="$(uname -s)"
  
  case "${kern_name}" in
    Darwin*)  os_name="Mac" ;;
    Linux*)   os_name="Linux" ;;
    MINGW*)   os_name="MinGW" ;;
    CYGWIN*)  os_name="Cygwin" ;;
    *)        os_name="UNKNOWN:${kern_name}" ;;
  esac
  
  echo "${os_name}"
}

arg_find_e() {
  case $(os_type) in
    "Mac") arg="-E" ;;
    *) arg="" ;;
  esac
  
  echo "${arg} "
}

cmd_md5sum() {
  case $(os_type) in
    "Mac") cmd="md5" ;;
    *) cmd="md5sum" ;;
  esac
  
  echo "${cmd}"
}

timer() {
  if [[ "$#" -eq 0 ]]; then
    date '+%s'
  else
    local stime=$1
    local -r etime="$(date '+%s')"
    
    if [[ -z "${stime}" ]]; then stime="${etime}"; fi
    local -r delta="$((etime - stime))"
    
    local -r sec="$((delta % 60))"
    if [[ "${delta}" -lt 60 ]]; then
      echo "${sec} sec"
    else
      local -r min="$(((delta / 60) % 60))"
      if [[ "${delta}" -lt 3600 ]]; then
        echo "${min} min ${sec} sec"
      else
        local -r hr="$((delta / 3600))"
        echo "${hr} hr ${min} min ${sec} sec"
      fi
    fi
  fi
}

#######################################
# Assign value to variable.
# Globals:
#   <none>
# Arguments:
#   $1: Name of variable to set
#   $2: Assignment value
# Returns:
#   0 if the variable is successfully set with the value specified;
#   non-zero if the variable has been previously set
#######################################
assign_var_once() {
  declare -r var_name="$1" value="$2"
  
  [[ -z "${!var_name:-}" ]] || return 1
  eval "${var_name}=${value}"
}

#######################################
# Assign value to variable, or exit if the variable has been previously set.
# Globals:
#   <none>
# Arguments:
#   $1: Name of variable to set
#   $2: Assignment value
#   $3 (optional): Error message
# Returns:
#  Variable set with the value specified
#######################################
assign_var_once_on_err_exit() {
  declare -r var_name="$1" value="$2" err_msg="$3"
  
  assign_var_once "${var_name}" "${value}" ||
  check_err "${err_msg:-"Cannot assign variable '${var_name}' multiple times"}"
}
