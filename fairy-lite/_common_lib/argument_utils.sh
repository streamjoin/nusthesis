#!/usr/bin/env bash
#
# Command-line argument utilities.
#
# Dependencies: output_utils.sh
#               system.sh

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
  eval "${flag_name}=true"
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
#   Variable set with the value specified
#######################################
arg_set_opt_var() {
  declare -r opt="$1" flag_name="$2" var_name="$3" value="$4"
  
  if [[ "${!flag_name:-}" = "true" ]]; then
    assign_var_once_on_err_exit "${var_name}" "${value}" \
    "Cannot apply option '${opt}' multiple times"
    
    unset -v "${flag_name}"
  fi
}

# TODO(linqian): Add function description.
check_dangling_arg_opt() {
  declare -r opt="$1" flag_name="$2"
  
  [[ -z "${!flag_name:-}" ]]
  check_err "Found redundant option '${opt}', or its value assignment is missing (see '--help' for usage)"
}
