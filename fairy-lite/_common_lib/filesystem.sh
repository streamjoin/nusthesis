#!/usr/bin/env bash
#
# Utilities for file and directory manipulation.

[[ -n "${__FAIRY_COMMON_LIB_FILESYSTEM_SH__+x}" ]] && return
readonly __FAIRY_COMMON_LIB_FILESYSTEM_SH__=1

# Include dependencies
[[ -n "${FAIRY_HOME+x}" ]] || readonly FAIRY_HOME="$(cd "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)/.."
# shellcheck disable=SC1090
source "${FAIRY_HOME}/_common_lib/output_utils.sh"

delete_file() {
  rm -f "$1"
  [[ ! -f "$1" ]] ||
  check_err "failed to delete file '$1'"
}

delete_dir() {
  rm -rf "$1"
  [[ ! -d "$1" ]] ||
  check_err "failed to delete directory '$1'"
}

try_delete_empty_dir() {
  rmdir --ignore-fail-on-non-empty "$1" ||
  warn "Failed to delete directory '$1': Permission denied"
}

find_and_link_files_by_ext() {
  [[ "$#" -eq 3 ]] ||
  check_err "wrong number of parameters to 'find_and_link_files_by_ext()'"
  
  local -r ext="$1"
  
  local -r from_dir="$2"
  [[ -d "${from_dir}" ]] ||
  check_err "invalid path of directory '${from_dir}'"
  
  local -r to_dir="$3"
  mkdir -p "${to_dir}"
  
  # shellcheck disable=SC2016
  find "${from_dir}" -maxdepth 1 -type f -iname "*.${ext}" -print0 |
  td="${to_dir}" xargs -0 -n 1 sh -c '[[ -f "$0" ]] && ln -s "$0" ${td}'
}

find_and_link_files_by_regex() {
  [[ "$#" -eq 3 ]] ||
  check_err "wrong number of parameters to 'find_and_link_files_by_regex()'"
  
  local regex="$1"
  [[ "$(os_type)" != "Mac" ]] &&
  regex="$(echo "${regex//|/\\|}" | sed 's/(/\\(/g' | sed 's/)/\\)/g')"
  
  local -r from_dir="$2"
  [[ -d "${from_dir}" ]] ||
  check_err "invalid path of directory '${from_dir}'"
  
  local -r to_dir="$3"
  mkdir -p "${to_dir}"
  
  # shellcheck disable=SC2016,SC2046
  find $(arg_find_e) "${from_dir}" -maxdepth 1 -type f -iregex "${regex}" -print0 |
  td="${to_dir}" xargs -0 -n 1 sh -c '[[ -f "$0" ]] && ln -s "$0" ${td}'
}

find_and_link_subdirs() {
  [[ "$#" -eq 2 ]] ||
  check_err "wrong number of parameters to 'find_and_link_subdirs()'"
  
  local -r from_dir="$1"
  [[ -d "${from_dir}" ]] ||
  check_err "invalid path of directory '${from_dir}'"
  
  local -r to_dir="$2"
  mkdir -p "${to_dir}"
  
  # shellcheck disable=SC2016
  find "${from_dir}/." -maxdepth 1 -type d -print0 |
  xargs -0 -n 1 bash -c 'basename -- "$0"' |
  fd="${from_dir}" td="${to_dir}" xargs -n 1 \
  bash -c '[[ "$0" != "." ]] && ln -s "${fd}/$0" "${td}"'
}

check_file_exists() {
  [[ "$#" -eq 1 ]] ||
  check_err "wrong number of parameters to 'check_file_exists()'"
  
  [[ -f "$1" ]] ||
  check_err "invalid path of file '$1'"
}

check_dir_exists() {
  [[ "$#" -eq 1 ]] ||
  check_err "wrong number of parameters to 'check_dir_exists()'"
  
  [[ -d "$1" ]] ||
  check_err "invalid path of directory '$1'"
}

file_size_bytes() {
  [[ "$#" -eq 1 ]] ||
  check_err "wrong number of parameters to 'get_file_size_bytes()'"
  
  check_file_exists "$1"
  
  # shellcheck disable=SC2012
  ls -l "$1" | awk '{ print $5 }'
}
