#!/usr/bin/env bash
#
# Compile LaTeX project.

set -o nounset
set -o errexit
set -o errtrace
set -o pipefail

# Name of the main .tex file
export TEX_NAME="main"

# Name of the output .pdf file
export PDF_NAME="ChickenR"

# Name of the .bib file used as the input to trimbib
export SRC_BIB_NAME="references"

# Path of the Fairy project
export FAIRY_HOME="../fairy"

# Command for compiling .tex
export CMD_LATEX="pdflatex"

# Command for compiling .bib
export CMD_BIBTEX="biber"

# Run build_latex.sh with the above settings
# shellcheck disable=SC1090
source "${FAIRY_HOME}/latex/build_latex.sh"
