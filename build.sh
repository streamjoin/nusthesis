#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail

# Name of the output .pdf file
PDF_NAME="ChickenR"

# Name of the main .tex file
TEX_NAME="thesis"

################################################

WORK_DIR=$(pwd)
SRC_DIR="${WORK_DIR}/src"
BUILD_DIR="${WORK_DIR}/pdfbuild"

delete() {
  if [[ -f $1 ]]; then rm $1; fi
}

delete_or_else_exit() {
  delete $1
  if [[ -f $1 ]]; then exit 1; fi
}

delete_or_else_exit ${PDF_NAME}.pdf

mkdir -p ${BUILD_DIR} 
rm -rf ${BUILD_DIR}/*

compile_tex() {
  pdflatex ${TEX_NAME}.tex -output-directory ${BUILD_DIR}
}

compile_bib() {
  biber ${BUILD_DIR}/${TEX_NAME}
}

cd ${SRC_DIR}
compile_tex 
compile_bib 
compile_tex
compile_tex

cd ${WORK_DIR}
mv ${BUILD_DIR}/${TEX_NAME}.pdf ${WORK_DIR}/${PDF_NAME}.pdf
rm -rf ${BUILD_DIR}

exit $?
