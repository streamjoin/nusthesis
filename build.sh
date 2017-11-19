#!/bin/sh
set -o nounset
set -o errexit
set -o pipefail

#### Begin of Configurations ####

# name of the output .pdf file
PDF_NAME="ChickenR"

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
TEX_FILE="${TEX_NAME}.tex"

pdflatex ${TEX_FILE}
biber ${TEX_NAME}
pdflatex ${TEX_FILE}
pdflatex ${TEX_FILE}

# rename output files
if [[ "${TEX_NAME}" != "${PDF_NAME}" ]]; then
	mv ${TEX_NAME}.pdf ${PDF_NAME}.pdf
fi

# clean and exit
sh delete_tmp.sh

exit $?
