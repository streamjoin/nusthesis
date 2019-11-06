# A LaTeX Template for PhD/Master Thesis of the National University of Singapore (NUS) #

This set of latex code (mainly the [`nusthesis.cls`](nusthesis.cls)) composes a template of NUS thesis, which is compliant with the [university's requirement](https://www.dropbox.com/s/o6jtrk9y7cil70w/General-Guidelines-and-Instructions-on-Format-of-Research-Thesis-and-Electronic-Submission.pdf?dl=0 "General Guidelines and Instructions on Format of Research Thesis and Electronic Submission").
Using this template to organize your thesis content can save a lot of effort spent on formatting. 

Apart from formatting, the example .tex files also include a lot of latex tricks extracted from my years' experience of using latex.
These tricks are mainly described and demonstrated in the `chapters/ch-Intro.tex` file. 

You may refer to [this](https://www.dropbox.com/s/rar6yxn9u6n19dp/ChickenR.pdf?dl=0) to preview a sample thesis generated using this template. In addition, the template is also available on [Overleaf](https://www.overleaf.com/latex/templates/thesis-template-of-the-national-university-of-singapore-nus/gkvbbgybrjnw) (but it may not be timely synchronized with updates maintained in this repository).

## Compilation ##

Run the `build.sh` script to compile in Linux, macOS or emulated Unix-like environment for Windows (e.g., [Cygwin](https://www.cygwin.com/) and [MinGW](http://www.mingw.org/ "Minimalist GNU for Windows")). ~~For compilation in the native Windows, run the `build.bat` script.~~ The produced .pdf file locates in the same folder. 

You may customize the name of the output .pdf file by configuring `PDF_NAME` in the above scripts. Alternatively, you could specify the filename with the `--pdf-name` option (or `-o` for short). For example, 

```
$ ./build.sh --pdf-name MyThesis
```

This will produce `MyThesis.pdf` as output.

ps: Since [Windows 10 already provides built-in Linux Bash Shell](https://www.howtogeek.com/249966/how-to-install-and-use-the-linux-bash-shell-on-windows-10/), the original crappy `build.bat` script has been deprecated. Nevertheless, you are still welcomed to provide a robust one via [pull request](https://github.com/streamjoin/nusthesis/pulls) if you believed that's really necessary.

### Manual Compilation ###

In case you prefer to compile the code manually, please run *exactly* the following commands at the project root (i.e., where the `main.tex` locates at the same directory level).

```
$ pdflatex main.tex
$ biber main
$ pdflatex main.tex
$ pdflatex main.tex
```

Note that the parameter to `biber` is the filename *without extension*. Moreover, you must run the second `pdflatex` to generate bibliography and resolve citations, and the third `pdflatex` to generate the bibliography entry in the table of contents. 

### Dependencies ###

- LaTeX ([MiKTeX](https://miktex.org/) or [TeX Live](https://www.tug.org/texlive/))
- [biber](http://biblatex-biber.sourceforge.net/ "Biber: A BibTeX replacement for users of BibLaTeX")

## Editing ##

Your edit should start with [`main.tex`](main.tex), which is also the compilation entry (as configured in [`build.sh`](build.sh)). Sources of individual chapters as well as abstract, acknowledgments, appendices, etc., are placed in the [`chapters`](chapters/) folder. Illustrative figures and analytical plottings should be stored in the [`pic`](pic/) and [`exp`](exp/) folders respectively. 

### Printing vs. Electronic ###

Uncomment the following line at the head of `main.tex` when you are producing the thesis for printing hard copies in a **double-sided** fashion. 

```latex
\newcommand*{\DoubleSided}{}
```

And comment it out when you are producing the electronic thesis for the final submission. 

## Contact ##

If you encounter any problem of using this template, feel free to [contact me](http://linqian.me/) or [create an issue](https://github.com/streamjoin/nusthesis/issues) in this repository. 

All the best for your graduation!

