# A LaTeX Template for PhD/Master Thesis of the National University of Singapore (NUS) #

This set of latex code (mainly the `src/nusthesis.cls` file) composes a template of NUS thesis, which is compliant with the [university requirement](https://www.dropbox.com/s/0jaf4nq8kl7mf7d/General-Guidelines-and-Instructions-on-Format-of-Research-Thesis-and-Electronic-Submission.pdf?dl=0 "General Guidelines and Instructions on Format of Research Thesis and Electronic Submission").
Using this template to organize your thesis content can save a lot of effort spent on formatting. 

Apart from formatting, the example .tex files also include a lot of latex tricks extracted from my years' experience of using latex.
These tricks are mainly described and demonstrated in the `src/ch-Intro.tex` file. 

You may refer to [this](https://www.dropbox.com/s/rar6yxn9u6n19dp/ChickenR.pdf?dl=0) to preview a sample thesis generated using this template.

## Compilation ##

Run the `build.sh` script to compile in Linux, macOS or emulated Unix-like environment for Windows (e.g., [Cygwin](https://www.cygwin.com/) and [MinGW](http://www.mingw.org/ "Minimalist GNU for Windows")).
For compilation in the native Windows, run the `build.bat` script.
The produced .pdf file locates in the same folder. 

You may customize the name of the output .pdf file by configuring `PDF_NAME` in the above scripts. 

## Dependencies ##

- LaTeX ([MiKTeX](https://miktex.org/) or [TeX Live](https://www.tug.org/texlive/))
- [biber](http://biblatex-biber.sourceforge.net/ "Biber: A BibTeX replacement for users of BibLaTeX")

## Contact ##

If you encounter any problem of using this template, feel free to contact me or create an issue in this repository. 

All the best for your graduation!
