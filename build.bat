@echo off

rem #### Begin of Configurations ####

set PDF_NAME="ChickenR"
set TEX_NAME="thesis"

rem #### End of Configurations ####

set WAIT_FOR_SEC=5

:main_entry
@del /F %PDF_NAME%.pdf
IF EXIST %PDF_NAME%.pdf goto err

set TEX_FILE="%TEX_NAME%.tex"

pdflatex %TEX_FILE%
biber %TEX_NAME%
pdflatex %TEX_FILE%
pdflatex %TEX_FILE%

if %TEX_NAME% neq %PDF_NAME% (
    rename %TEX_NAME%.pdf %PDF_NAME%.pdf
)

delete_tmp.bat
goto end

:err
@echo Error: PDF file is in use! (auto-retry in %WAIT_FOR_SEC% seconds)
timeout %WAIT_FOR_SEC%
goto main_entry

:end
@echo "OK!"
