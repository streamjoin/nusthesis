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

# Name of the .bib file used as the parameter to \bibliography{}
export TGT_BIB_NAME="references"

# Path of the Fairy(-lite) project
# Note: You may get the update, if any, of the compilation script by cloning
#       the latest Fairy project from https://github.com/streamjoin/fairy
export FAIRY_HOME="./fairy-lite"

# Command for compiling .tex
export CMD_LATEX="pdflatex"

# Command for compiling .bib
export CMD_BIBTEX="biber"

# Path of the trimbib.jar, or <none> for skipping the trimbib processing
# You may need to clone the project from https://github.com/streamjoin/trimbib
export TRIMBIB_JAR="<none>"

# Configuration of trimbib
export TRIMBIB_ARGS=("--pages")

# Run build_latex.sh with the above settings
# shellcheck disable=SC1090
source "${FAIRY_HOME}/latex/build_latex.sh"
