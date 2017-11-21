@echo off

rem #### Begin of Configurations ####

set PDF_NAME="ChickenR"
set SRC_DIR="src"
set TEX_NAME="thesis"

rem #### End of Configurations ####

set WAIT_FOR_SEC=5

:main_entry
@del /F %PDF_NAME%.pdf
IF EXIST %PDF_NAME%.pdf goto err

set WORK_DIR="%CD%"
set COMPILE_TEX=pdflatex %TEX_NAME%.tex -output-directory %WORK_DIR%
set COMPILE_BIB=biber %WORK_DIR%/%TEX_NAME%

cd %SRC_DIR%
%COMPILE_TEX%
%COMPILE_BIB%
%COMPILE_TEX%
%COMPILE_TEX%
cd %WORK_DIR%

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
