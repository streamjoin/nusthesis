#!/usr/bin/env bash
#
# Execution of compiling LaTeX project.

# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o nounset
# Exit on error. Append "|| true" if you expect an error.
set -o errexit
# Exit on error inside any functions or subshells.
set -o errtrace
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
set -o pipefail
# Turn on traces, useful while debugging but commented out by default
# set -o xtrace

IFS=$'\t\n'    # Split on newlines and tabs (but not on spaces)

[[ -n "${__SCRIPT_DIR+x}" ]] || readonly __SCRIPT_DIR="$(cd "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
[[ -n "${__SCRIPT_NAME+x}" ]] || readonly __SCRIPT_NAME="$(basename -- "$0")"

# Include libraries
[[ -n "${FAIRY_HOME+x}" ]] || readonly FAIRY_HOME="${__SCRIPT_DIR}/.."
# shellcheck disable=SC1090
source "${FAIRY_HOME}/_common_lib/argument_utils.sh"
# shellcheck disable=SC1090
source "${FAIRY_HOME}/_common_lib/filesystem.sh"
# shellcheck disable=SC1090
source "${FAIRY_HOME}/_common_lib/output_utils.sh"
# shellcheck disable=SC1090
source "${FAIRY_HOME}/_common_lib/system.sh"

# Global variables
[[ -n "${__START_TIME+x}" ]] || readonly __START_TIME="$(timer)"

# The main function
main() {
  check_args "$@"
  set_globals
  
  info "This is Fairy LaTeX Compilation (under the MIT License)"
  pushd "${WORK_DIR}" >/dev/null
  clean_all
  if [[ -z "${FLAG_ARG_CLEAN_ONLY:-}" ]]; then
    mkdir -p "${BUILD_DIR}"
    prepare_bib
    compile
    deliver
    finish
    delete_dir "${BUILD_DIR}"
  fi
  popd >/dev/null
}

set_globals() {
  WORK_DIR="${WORK_DIR:-"$(dirname -- "$0")"}"
  check_dir_exists "${WORK_DIR}"
  readonly WORK_DIR="$(cd "${WORK_DIR}"; pwd -P)"  # canonical path
  
  BUILD_DIR="${BUILD_DIR:-"${WORK_DIR}/pdfbuild"}"
  mkdir -p "${BUILD_DIR}"
  readonly BUILD_DIR="$(cd "${BUILD_DIR}"; pwd -P)"  # canonical path
  
  TEX_NAME="${TEX_NAME:-}"
  if [[ -n "${TEX_NAME}" ]]; then
    check_file_exists "${WORK_DIR}/${TEX_NAME}.tex"
  elif [[ -f "${WORK_DIR}/main.tex" ]]; then
    TEX_NAME="main"
  elif [[ -f "${WORK_DIR}/ms.tex" ]]; then
    TEX_NAME="ms"
  fi
  check_err "'TEX_NAME' undefined: name of the main .tex file"
  readonly TEX_NAME="${TEX_NAME%.tex}"
  
  PDF_NAME="${ARG_PDF_NAME:-"${PDF_NAME:-${TEX_NAME}}"}"
  readonly PDF_NAME="${PDF_NAME%.pdf}"
  
  readonly CMD_LATEX="${CMD_LATEX:-"latex"}"
  check_cmd_exists "${CMD_LATEX}" "compile .tex"
  
  CMD_BIBTEX="${CMD_BIBTEX-"bibtex"}"
  [[ "${CMD_BIBTEX}" = "<none>" ]] && CMD_BIBTEX=""
  readonly CMD_BIBTEX
  [[ -z "${CMD_BIBTEX}" ]] || check_cmd_exists "${CMD_BIBTEX}" "compile .bib"
  
  TRIMBIB_JAR="${TRIMBIB_JAR-"${TRIMBIB_HOME:+"${TRIMBIB_HOME}/release/trimbib.jar"}"}"
  [[ "${TRIMBIB_JAR}" = "<none>" ]] && TRIMBIB_JAR=""
  readonly TRIMBIB_JAR
  [[ -z "${TRIMBIB_JAR}" ]] || check_file_exists "${TRIMBIB_JAR}"
  
  readonly TRIMBIB_LOG="${TRIMBIB_LOG:-"trimbib_log.txt"}"
}

clean_all() {
  printf "Cleaning up previously generated files ... "
  
  delete_file "${WORK_DIR}/${PDF_NAME}.pdf"
  delete_file "${WORK_DIR}/${PDF_NAME}.md5"
  delete_file "${WORK_DIR}/${TEX_NAME}.aux"
  
  [[ -n "${CMD_BIBTEX}" ]] && delete_file "${WORK_DIR}/${TEX_NAME}.bbl"
  
  [[ "${BUILD_DIR}" != "${WORK_DIR}" ]]
  check_err "The build directory cannot be the working directory itself"
  delete_dir "${BUILD_DIR}"
  
  echo "done"
}

prepare_bib() {
  [[ -n "${CMD_BIBTEX}" ]] || return 0
  
  local -r src_bib="${SRC_BIB_NAME:-}.bib"
  
  local -r tgt_bib_name="${TGT_BIB_NAME:-"${SRC_BIB_NAME:+"${SRC_BIB_NAME}-trim"}"}"
  [[ "${tgt_bib_name}" != "${SRC_BIB_NAME:-}" ]]
  check_err "Target .bib cannot be the source .bib itself"
  
  if [[ -n "${TRIMBIB_JAR}" ]] && [[ -f "${WORK_DIR}/${src_bib}" ]]; then
    readonly TGT_BIB="${tgt_bib_name}.bib"
    
    printf "Formatting %s ... " "${WORK_DIR}/${src_bib}"
    
    check_cmd_exists "java"
    java -jar "${TRIMBIB_JAR}" -i "${WORK_DIR}/${src_bib}" -d "${WORK_DIR}" \
    -o "${TGT_BIB}" --overwrite "${TRIMBIB_ARGS[@]}" \
    > "${WORK_DIR}/${TRIMBIB_LOG}" 2>&1
    check_err "Failed to format '${WORK_DIR}/${src_bib}'"
    
    echo "done"
    info "Formatted bib: ${WORK_DIR}/${TGT_BIB}"
    info "Log of bib formatting: ${WORK_DIR}/${TRIMBIB_LOG}"
    
  else  # no bib formatting to perform
    if [[ -f "${WORK_DIR}/${tgt_bib_name}.bib" ]]; then
      readonly TGT_BIB="${tgt_bib_name}.bib"
    elif [[ -f "${WORK_DIR}/${src_bib}" ]]; then
      readonly TGT_BIB="${src_bib}"
    else
      check_err "Failed to find .bib file"
    fi
  fi
  
  ln -s "${WORK_DIR}/${TGT_BIB}" "${BUILD_DIR}/${TGT_BIB}"
  
  find_and_link_files_by_ext "bst" "${WORK_DIR}" "${BUILD_DIR}" || true
}

compile() {
  compile_tex
  [[ -n "${CMD_BIBTEX}" ]] && compile_bib && compile_tex && compile_tex
  
  if [[ "${CMD_LATEX}" = "latex" ]]; then
    find_and_link_subdirs "${WORK_DIR}" "${BUILD_DIR}" || true
    
    find_and_link_files_by_regex ".*\.(eps|ps|pdf|jpg|jpeg|png|bmp)$" \
    "${WORK_DIR}" "${BUILD_DIR}" || true
    
    (
      cd "${BUILD_DIR}"
      dvips -P pdf -t letter -o "${TEX_NAME}.ps" "${TEX_NAME}.dvi"
      ps2pdf -dPDFSETTINGS#/prepress -dCompatibilityLevel#1.4 \
      -dSubsetFonts#true -dEmbedAllFonts#true \
      "${TEX_NAME}.ps" "${TEX_NAME}.pdf"
    )
  fi
}

compile_tex() {
  case "${CMD_LATEX}" in
    "latex"|"xelatex")
      ${CMD_LATEX} -output-directory="${BUILD_DIR}" \
      -aux-directory="${BUILD_DIR}" "${TEX_NAME}.tex"
    ;;
    "pdflatex")
      ${CMD_LATEX} --shell-escape \
      -output-directory "${BUILD_DIR}" "${TEX_NAME}.tex"
    ;;
    *)
      err "unknown latex command '${CMD_LATEX}'"
      exit 127
    ;;
  esac
  check_err "Failed to compile '${TEX_NAME}.tex'"
}

compile_bib() {
  (
    cd "${BUILD_DIR}"
    case "${CMD_BIBTEX}" in
      "bibtex")
        ${CMD_BIBTEX} "${TEX_NAME}.aux"
      ;;
      "biber")
        ${CMD_BIBTEX} "${TEX_NAME}"
      ;;
      *)
        err "Unknown bib command '${CMD_BIBTEX}'"
        exit 127
      ;;
    esac
  )
  check_err "Failed to compile '\\\\bibliography{${TGT_BIB%.*}}'"
}

deliver() {
  mv "${BUILD_DIR}/${TEX_NAME}.pdf" "${WORK_DIR}/${PDF_NAME}.pdf"
  mv "${BUILD_DIR}/${TEX_NAME}.aux" "${WORK_DIR}/${TEX_NAME}.aux"
  
  [[ -n "${CMD_BIBTEX}" ]] &&
  mv "${BUILD_DIR}/${TEX_NAME}.bbl" "${WORK_DIR}/${TEX_NAME}.bbl"
  
  readonly CMD_MD5SUM="$(cmd_md5sum)"
  [[ "$(command -v "${CMD_MD5SUM}")" ]] &&
  ${CMD_MD5SUM} "${WORK_DIR}/${PDF_NAME}.pdf" > "${WORK_DIR}/${PDF_NAME}.md5"
}

finish() {
  local -r pdf_bytes="$(file_size_bytes "${PDF_NAME}.pdf")"
  info "------------------------------------------------------------------------"
  info_bold_green "BUILD SUCCESSFUL"
  info "------------------------------------------------------------------------"
  info "Output: ${WORK_DIR}/${PDF_NAME}.pdf (${pdf_bytes} bytes)"
  info "Finished at: $(date +"%T %Z, %-d %B %Y")"
  info "Total time: $(timer "${__START_TIME}")"
  info "------------------------------------------------------------------------"
}

#######################################
# Check and process command-line arguments.
# Globals:
#   <none>
# Arguments:
#   Command-line arguments
# Returns:
#   Variables and flags set according to the command-line arguments
#######################################
check_args() {
  # unset variables of option flags
  unset -v FLAG_ARG_CLEAN_ONLY
  unset -v FLAG_ARG_SET_PDF_NAME
  
  # process each command-line argument
  for arg in "$@"; do
    case "${arg}" in
      # Print help message
      '--help'|'-h'|'-?' )
        print_usage
        exit 0
      ;;
      # Option for clearning all generated files
      '--clean'|'-c' )
        deal_with_arg_opt "--clean" "FLAG_ARG_CLEAN_ONLY"
      ;;
      '--pdf-name'|'-o' )
        deal_with_arg_opt "--pdf-name" "FLAG_ARG_SET_PDF_NAME"
      ;;
      # Unknown options
      '-'* )
        err "Unknown command argument(s) '${arg}' (see '--help' for usage)"
        exit 126
      ;;
      # Default: assign variable
      * )
        arg_set_opt_var "--pdf-name" "FLAG_ARG_SET_PDF_NAME" "ARG_PDF_NAME" "${arg}" ||
        arg_set_pos_var "${arg}"    # KEEP THIS AT THE TAIL
      ;;
    esac
  done
  
  # sanity check
  check_dangling_arg_opt "--pdf-name" "FLAG_ARG_SET_PDF_NAME"
}

print_usage() {
cat <<EndOfMsg
Usage: ${__SCRIPT_NAME} [OPTION]...

Options:
  -h, -?, --help          display this help and exit
  -c, --clean             delete all generated files and exit
  -o, --pdf-name <str>    specify filename of the generated .pdf

EndOfMsg
}

# Execution (SHOULDN'T EDIT AFTER THIS LINE!)
main "$@"
[[ "$0" != "${BASH_SOURCE[0]}" ]] || exit 0
