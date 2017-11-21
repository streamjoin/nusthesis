@echo off

rem Name of the output .pdf file
set PDF_NAME=ChickenR

rem Name of the main .tex file
set TEX_NAME=thesis

rem ############################################

set RETRY_AFTER_SEC=5

:main_entry
@del /F %PDF_NAME%.pdf
IF EXIST %PDF_NAME%.pdf goto err

set WORK_DIR=%CD%
set SRC_DIR=%WORK_DIR%\src
set BUILD_DIR=%WORK_DIR%\pdfbuild

set COMPILE_TEX=pdflatex %TEX_NAME%.tex -output-directory %BUILD_DIR%
set COMPILE_BIB=biber %BUILD_DIR%/%TEX_NAME%

cd %SRC_DIR%
%COMPILE_TEX%
%COMPILE_BIB%
%COMPILE_TEX%
%COMPILE_TEX%

cd %WORK_DIR%
move %BUILD_DIR%\%TEX_NAME%.pdf %WORK_DIR%\%PDF_NAME%.pdf
rmdir /S /Q %BUILD_DIR%
goto end

:err
@echo Error: PDF file is in use! (auto-retry in %RETRY_AFTER_SEC% seconds)
timeout %RETRY_AFTER_SEC%
goto main_entry

:end
@echo OK!
