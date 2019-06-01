#!/usr/bin/env bash
#
# Command-line argument utilities.

[[ -n "${__FAIRY_COMMON_LIB_ARGUMENT_UTILS_SH__+x}" ]] && return
readonly __FAIRY_COMMON_LIB_ARGUMENT_UTILS_SH__=1

# Include dependencies
[[ -n "${FAIRY_HOME+x}" ]] || readonly FAIRY_HOME="$(cd "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)/.."
# shellcheck disable=SC1090
source "${FAIRY_HOME}/_common_lib/output_utils.sh"
# shellcheck disable=SC1090
source "${FAIRY_HOME}/_common_lib/system.sh"

#######################################
# Handler of argument option.
# Globals:
#   <none>
# Arguments:
#   $1: Option descriptor
#   $2: Name of flag variable
# Returns:
#   Flag variable set according to the option
#######################################
deal_with_arg_opt() {
  declare -r opt="$1" flag_name="$2"
  
  check_dangling_arg_opt "${opt}" "${flag_name}"
  eval "${flag_name}=1"
}

#######################################
# Handler of argument variable assignment.
# Globals:
#   <none>
# Arguments:
#   $1: Option descriptor
#   $2: Name of flag variable
#   $3: Name of variable to set
#   $4: Assignment value
# Returns:
#   0 if the variable is set with the value specified;
#   non-zero if no assignment is executed
#######################################
arg_set_opt_var() {
  declare -r opt="$1" flag_name="$2" var_name="$3" value="$4"
  
  [[ -n "${!flag_name+x}" ]] || return 1
  
  assign_var_once_on_err_exit "${var_name}" "${value}" \
  "Cannot apply option '${opt}' multiple times"
  
  unset -v "${flag_name}"
}

#######################################
# Handler of positional argument variable assignment.
# Globals:
#   <none>
# Arguments:
#   $1: Assignment value
# Returns:
#   Variable "ARG_POS_VAR_X" set with the value specified,
#   where "X" is the positional index starting from 1
#######################################
arg_set_pos_var() {
  declare -r value="$1"
  
  __POS_ARG_CURSOR="${__POS_ARG_CURSOR:-0}"
  ((++__POS_ARG_CURSOR))
  eval "ARG_POS_VAR_${__POS_ARG_CURSOR}=${value}"
}

#######################################
# Check dangling argument option and exit on error.
# Globals:
#   <none>
# Arguments:
#   $1: Option descriptor
#   $2: Name of flag variable
# Returns:
#   <none>
#######################################
check_dangling_arg_opt() {
  declare -r opt="$1" flag_name="$2"
  
  [[ -z "${!flag_name-}" ]]
  check_err "Found redundant option '${opt}', or its value assignment is missing (see '--help' for usage)"
}
