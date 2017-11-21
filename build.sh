#!/bin/sh
set -o nounset
set -o errexit
set -o pipefail

#### Begin of Configurations ####

# name of the output .pdf file
PDF_NAME="ChickenR"

# folder containing source code
SRC_DIR="src"

# name of the main .tex file
TEX_NAME="thesis"

#### End of Configurations ####

delete() {
	if [[ -f $1 ]]; then 
		rm $1
	fi
}

delete_or_else_exit() {
	delete $1
	if [[ -f $1 ]]; then 
		exit 1
	fi
}

delete_or_else_exit ${PDF_NAME}.pdf

# compile
WORK_DIR=$(pwd)

COMPILE_TEX="pdflatex ${TEX_NAME}.tex -output-directory ${WORK_DIR}"
COMPILE_BIB="biber ${WORK_DIR}/${TEX_NAME}"

cd ${SRC_DIR}
${COMPILE_TEX}
${COMPILE_BIB}
${COMPILE_TEX}
${COMPILE_TEX}
cd ${WORK_DIR}

# rename output files
if [[ "${TEX_NAME}" != "${PDF_NAME}" ]]; then
	mv ${TEX_NAME}.pdf ${PDF_NAME}.pdf
fi

# clean and exit
sh delete_tmp.sh

exit $?
