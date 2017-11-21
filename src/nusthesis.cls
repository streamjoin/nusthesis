%% nusthesis.cls 2017-11-17
%% Copyright (C) 2017 Qian Lin.
%
% This file is modified based ucbthesis.cls.
%
%% ucbthesis.cls 2014-04-11
%% Copyright (C) 1988-2014 Daniel Gildea, BBF, Ethan Munson, Paul Vojta.
%
% This work may be distributed and/or modified under the
% conditions of the LaTeX Project Public License, either version 1.3
% of this license or (at your option) any later version.
% The latest version of this license is in
%   http://www.latex-project.org/lppl.txt
% and version 1.3 or later is part of all distributions of LaTeX
% version 2003/12/01 or later.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{nusthesis}[2017/11/17 v1.0 National University of Singapore Thesis Class]

%    ****************************************
%    *               OPTIONS                *
%    ****************************************
%
%  The Graduate Division requirements essentially require that theses be
%  formatted as if the oneside option had been used.  In the memoir class,
%  however, twoside is the default.  The following code relies on the memoir
%  class for oneside/twoside formatting, but changes the default to oneside.
%  Ideas for this code were adapted from an answer on stackexchange,
%    http://tex.stackexchange.com/questions/12933/new-options-and-loaded-class-options-bug
%  (accessed on 12 September 2011).

\newcommand\thes@sidedness{-1}
\DeclareOption{oneside}
  {\renewcommand\thes@sidedness{1}\PassOptionsToClass{\CurrentOption}{memoir}}
\DeclareOption{twoside}
  {\renewcommand\thes@sidedness{2}\PassOptionsToClass{\CurrentOption}{memoir}
   \newcommand*{\pagedoublesided}{}}

%  Changing the default point size from 10pt to 12pt uses a similar procedure,
%  but it's messier.

\newcommand\thes@ptsize{0}
\DeclareOption{9pt}
  {\renewcommand\thes@ptsize{9}\PassOptionsToClass{\CurrentOption}{memoir}}
\DeclareOption{10pt}
  {\renewcommand\thes@ptsize{10}\PassOptionsToClass{\CurrentOption}{memoir}}
\DeclareOption{11pt}
  {\renewcommand\thes@ptsize{11}\PassOptionsToClass{\CurrentOption}{memoir}}
\DeclareOption{12pt}
  {\renewcommand\thes@ptsize{12}\PassOptionsToClass{\CurrentOption}{memoir}}
\DeclareOption{14pt}
  {\renewcommand\thes@ptsize{14}\PassOptionsToClass{\CurrentOption}{memoir}}
\DeclareOption{17pt}
  {\renewcommand\thes@ptsize{17}\PassOptionsToClass{\CurrentOption}{memoir}}
\DeclareOption{20pt}
  {\renewcommand\thes@ptsize{20}\PassOptionsToClass{\CurrentOption}{memoir}}
\DeclareOption{25pt}
  {\renewcommand\thes@ptsize{25}\PassOptionsToClass{\CurrentOption}{memoir}}
\DeclareOption{30pt}
  {\renewcommand\thes@ptsize{30}\PassOptionsToClass{\CurrentOption}{memoir}}
\DeclareOption{36pt}
  {\renewcommand\thes@ptsize{36}\PassOptionsToClass{\CurrentOption}{memoir}}
\DeclareOption{48pt}
  {\renewcommand\thes@ptsize{48}\PassOptionsToClass{\CurrentOption}{memoir}}
\DeclareOption{60pt}
  {\renewcommand\thes@ptsize{60}\PassOptionsToClass{\CurrentOption}{memoir}}
\DeclareOption{*pt}
  {\renewcommand\thes@ptsize{99}\PassOptionsToClass{\CurrentOption}{memoir}}

% Other options are passed on to the memoir class.

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{memoir}}

% The \ProcessOptions command causes the execution of every option command
% FOO which is declared and for which the user typed the FOO option in his
% \documentclass.  For every undeclared option BAR there will be a warning
% message. (BBF 10/31/94)

\ProcessOptions\relax

\ifnum\thes@sidedness<0
  \PassOptionsToClass{oneside}{memoir}
  \renewcommand\thes@sidedness{1}
\fi

\ifnum\thes@ptsize=0
  \PassOptionsToClass{12pt}{memoir}
  \renewcommand\thes@ptsize{12}
\fi

% Now load the memoir class, and configure it appropriately.

\LoadClass{memoir}

\setlrmarginsandblock{1.2in}{*}{*}
  \@tempdima=1in  \advance\@tempdima 25pt \advance\@tempdima\normalbaselineskip
  \@tempdimb=.75in  \advance\@tempdimb 30pt
\setulmarginsandblock{\@tempdima}{\@tempdimb}{*}

\AtBeginDocument{\checkandfixthelayout}

% The Grad. Division requires that "Placement of page numbers must be
% at the center of bottom."

\pagestyle{simple}
\makeevenhead{simple}{\leftmark}{}{}
\makeoddhead{simple}{}{}{\rightmark}
\makeevenfoot{simple}{}{\thepage}{}
\makeoddfoot{simple}{}{\thepage}{}
\aliaspagestyle{book}{simple}
\aliaspagestyle{part}{simple}
\aliaspagestyle{chapter}{simple}
\aliaspagestyle{title}{simple}

% Issue warnings if the settings are not appropriate for a final copy

\ifnum\thes@sidedness=2\relax
  \ifdraftdoc\else
  \ClassWarningNoLine{nusthesis}{^^J\@spaces
 ****** Use the twoside option only for drafts. \@spaces\@spaces ******}
\fi\fi

\ifnum\thes@ptsize<12\relax
  \ifdraftdoc\else
  \ClassWarningNoLine{nusthesis}{^^J\@spaces
 ****** Use the \thes@ptsize pt option only for drafts. \@spaces\@spaces
 ******^^J\@spaces
 ****** The Graduate Division requires 12-point type ******^^J\@spaces
 ****** or larger for the final version.\space\@spaces\@spaces\@spaces
 ******}
\fi\fi

% For some environments we switch back to single-spacing, also
% provides \dsp in case you need double-spacing where single-spacing
% is otherwise used.

\newcommand\ssp{\SingleSpacing}
\newcommand\dsp{\setSpacing{1.37}}

% For clear page

\let\origdoublepage\cleardoublepage
\newcommand{\clearemptydoublepage}{%
  \clearpage{\pagestyle{empty}\origdoublepage}}

\newcommand{\intendclearpage}{
  \ifdefined\pagedoublesided\clearemptydoublepage\else\clearpage\fi}

% Table of contents, lists of figures, and lists of tables should always
% be single-spaced.  If one wants them to be double-spaced instead (in a
% double-spaced document), the original macros are available as
% \memoirtableofcontents, \memoirlistoffigures, and \memoirlistoftables.

\let\memoirtableofcontents=\tableofcontents
\renewcommand\tableofcontents{\begin{SingleSpace}\memoirtableofcontents
  \end{SingleSpace}}

\let\memoirlistoffigures=\listoffigures
\renewcommand\listoffigures{\begin{SingleSpace}\memoirlistoffigures
  \end{SingleSpace}}

\let\memoirlistoftables=\listoftables
\renewcommand\listoftables{\begin{SingleSpace}\memoirlistoftables
  \end{SingleSpace}}


% Customized names:
\newcommand\acknowledgename{Acknowledgments}
\newcommand\declearname{Declaration}

%    ****************************************
%    *             FRONT MATTER             *
%    ****************************************
%

% DECLARATIONS
%
% These macros are used to declare arguments needed for the
% construction of the front matter.

% The year the degree will be officially conferred
\def\degreeyear#1{\gdef\@degreeyear{#1}}

% The full (unabbreviated) name of the degree
\def\degree#1{\gdef\@degree{#1}}

% All previous degrees: one per line in chronological order
\def\prevdegrees#1{\gdef\@prevdegrees{#1}}

% The name of your supervisors
\def\supervisor#1{\gdef\@supervisor{#1}}
\def\cosupervisor#1{\gdef\@cosupervisor{#1}}
\def\anothercosupervisor#1{\gdef\@anothercosupervisor{#1}}

% The names of your thesis examiners, one per line
\def\examiners#1{\gdef\@examiners{#1}}

% The name of your degree's field (e.g. Psychology, Computer Science)
\def\field#1{\gdef\@field{#1}}

% The declaration date
\def\declaredate#1{\gdef\@declaredate{#1}}

% The declaration signature
\def\declaresign#1{\gdef\@declaresign{#1}}

% The alwayssingle environment ensures that front matter is always
% single column even in a double-column document.

\newenvironment{alwayssingle}
  {\if@twocolumn \@restonecoltrue\onecolumn \else \@restonecolfalse\newpage \fi}
  {\if@restonecol \twocolumn \else \newpage \fi}

% \maketitle outputs the complete titlepage.  It requires all the
% above macros.

% Set the font that will be used in the front matter headings
\def\fmfont{\fontsize\@xiipt{14.5}\selectfont}

% Set the block letter that will be used in the title page
\def\blocklt#1{\textbf{\MakeUppercase{#1}}}

\def\maketitle{
{\ssp
  \makeatletter
    \setlength{\@tempdima}{28pt}\advance\@tempdima-\baselineskip
    \parskip=\@tempdima minus 4pt
  \makeatother
\begin{alwayssingle}
  \hrule height 0pt
  % Fix things so that they're vertically centered
  % \@tempdima = 2 * ((\stockheight-\textheight) / 2 - \uppermargin) - \topskip
    \@tempdima=\stockheight
    \advance\@tempdima-\textheight
    \advance\@tempdima-2\uppermargin
    \advance\@tempdima-\topskip
    \vspace{\@tempdima}
  \vfill
  \let\footnotesize\small
  \let\footnoterule\relax
  \thispagestyle{empty}
  \setcounter{page}{1}

  \begin{center}
    \blocklt{\@title}\par
    \vspace{14pt minus 4pt}
    by \par
    \blocklt{\@author}
    \ifdefined \@prevdegrees
      \par\vspace{-10pt}\textit{(\@prevdegrees)}
    \fi\par
    \vspace{28pt minus 8pt}
    \blocklt{A thesis submitted for the degree of} \par
    \blocklt{\@degree}\par
    in \par
    \blocklt{\@field}\par
    in the \par
    \blocklt{Graduate Division} \par
    of the \par
    \blocklt{National University of Singapore} \par
    \vspace{28pt minus 8pt}
    \blocklt{\@degreeyear} \par
    \vspace{14pt minus 4pt}
    \ifdefined \@cosupervisor
      Supervisors: \par\vspace{-10pt}
      {\@supervisor}, Main Supervisor \\
      {\@cosupervisor}, Co-Supervisor
      \ifdefined \@anothercosupervisor
        \\{\@anothercosupervisor}, Co-Supervisor
      \fi
    \else
      Supervisor: \par\vspace{-10pt}
      {\@supervisor}
    \fi\par
    \ifdefined \@examiners
      \vspace{5pt}
      Examiners: \par\vspace{-10pt}
      {\@examiners}\par
    \fi
  \end{center}
  \vfill
  \hrule height 0pt
\end{alwayssingle}

\setcounter{footnote}{0}
}}

% DECLARATION
%
% The declaration environment puts a large, bold, centered
% "Declaration" label at the top of the page.

\def\declarationpage{%
  \intendclearpage
  \thispagestyle{empty}
  \begin{alwayssingle}
  \begin{center}
    {\Large \bfseries \declearname}\par
    \vspace{1in}
    {\large 
    I hereby declare that this thesis is my original work and it has\par 
     been written by me in its entirety. I have duly\par 
    acknowledged all the sources of information which have\par
    been used in the thesis.\par
    \vspace{1.5em}
    This thesis has also not been submitted for any\par
    degree in any university previously.\par
    \ifdefined \@declaresign
      \vspace{1.2in}
      \begin{figure}[!h]
        \centering\includegraphics[height=1in]{\@declaresign}
      \end{figure}
      \vspace{-0.4in}
    \else 
      \vspace{2.1in}
    \fi
    $\rule{15em}{0.15mm}$ \par
    \vspace{.5em}
    {\normalsize\@author}\par
    \ifdefined\@declaredate
      {\normalsize\@declaredate}\par
    \fi
    }
  \end{center}
  \end{alwayssingle}
  \intendclearpage
}

% ABSTRACT
%
% The ABSTRACT environment allows for multi-page abstracts which,
% in accordance with UC rules, is numbered separately from the rest
% of the rest of the thesis in Arabic. 

\def\abstract{
  \intendclearpage
  \phantomsection\addcontentsline{toc}{chapter}{\abstractname}
  \begin{alwayssingle}
  \begin{center}{
    \ssp\fmfont
    {\large \bfseries \abstractname}\par
    \vspace{.5in}
    \@title\par
    \vspace{.1in}
    by\par
    \vspace{.1in}
    \@author\par
    \vspace{.1in}
    {\@degree} in \@field\par
    \vspace{.1in}
    National University of Singapore\par
  }
  \vspace{.1in}
  \end{center}
}

\def\endabstract{\par\vfil\null\end{alwayssingle}}

% DEDICATION
%
% The dedication environment just makes sure the dedication gets its
% own page.

\newenvironment{dedication}
  {\intendclearpage
   \begin{alwayssingle}
   \null\vfil
   \begin{center}\itshape\Large}
  {\end{center}
   \vfil\null
   \end{alwayssingle}}

% Convenient for short dedication
\newcommand{\dedicate}[1]{\begin{dedication}#1\end{dedication}}

% ACKNOWLEDGEMENTS
%
% The acknowledgments environment puts a large, bold, centered
% "Acknowledgements" label at the top of the page.

\newenvironment{acknowledgments}
  {\intendclearpage
   \phantomsection\addcontentsline{toc}{chapter}{\acknowledgename}
   \begin{alwayssingle}
   \begin{center}
   {\large \bfseries \acknowledgename}
   \end{center}
  }
  {\end{alwayssingle}}

% FRONTMATTER environment
%
% The FRONTMATTER environment makes sure that page numbering is set
% correctly (roman, lower-case, starting at 3) for the front matter
% that follows the abstract.  It also resets page-numbering for
% the remainder of the thesis (arabic, starting at 1).

\renewenvironment{frontmatter}
  {\setcounter{page}{1}\renewcommand{\thepage}{\roman{page}}}
  {\intendclearpage
   \newpage\renewcommand{\thepage}{\arabic{page}}\setcounter{page}{1}}

% Re-defining \tableofcontents, \listoffigures and \listoftables to 
% avoid self-referencing. 

\renewcommand{\tableofcontents}{
  \intendclearpage
  \phantomsection\pdfbookmark[chapter]{\contentsname}{toc}
  \chapter*{\contentsname}\vspace{2em}\makeatletter\@starttoc{toc}\makeatother}

\renewcommand{\listoffigures}{
  \intendclearpage
  \phantomsection\addcontentsline{toc}{chapter}{List of Figures}
  \chapter*{List of Figures}\vspace{2em}\makeatletter\@starttoc{lof}\makeatother}

\renewcommand{\listoftables}{
  \intendclearpage
  \phantomsection\addcontentsline{toc}{chapter}{List of Tables}
  \chapter*{List of Tables}\vspace{2em}\makeatletter\@starttoc{lot}\makeatother}

\usepackage[sf]{titlesec}
\titleformat{\chapter}[display]{\normalfont\huge\bfseries\ssp}{\chaptertitlename\ \thechapter}{20pt}{\Huge}
\titleformat{\section}{\normalfont\Large\bfseries\ssp}{\thesection}{1em}{}
\titleformat{\subsection}{\normalfont\large\bfseries\ssp}{\thesubsection}{1em}{}
\titleformat{\subsubsection}{\normalfont\normalsize\bfseries\ssp}{\thesubsubsection}{1em}{}
\titleformat{\paragraph}[runin]{\normalfont\normalsize\bfseries\ssp}{\theparagraph}{1em}{}
\titleformat{\subparagraph}[runin]{\normalfont\normalsize\bfseries\ssp}{\thesubparagraph}{1em}{}

\titlespacing*{\chapter}{0pt}{3.5ex}{2.5ex}
\titlespacing*{\section}{0pt}{.5ex plus .2ex minus .2ex}{1.5ex plus .2ex}
\titlespacing*{\subsection}{0pt}{.3ex plus .1ex minus .1ex}{1ex plus .2ex}
\titlespacing*{\subsubsection}{0pt}{.2ex}{.5ex plus .1ex}
\titlespacing*{\paragraph} {0pt}{.2ex plus .05ex minus .05ex}{1em}
\titlespacing*{\subparagraph}{\parindent}{.2ex plus .05ex minus .05ex}{1em}

\usepackage{epsfig, epstopdf, graphicx}
\usepackage{amssymb, mathrsfs, amsfonts}
\usepackage[cmex10]{amsmath}
\usepackage[mathscr]{euscript}

\usepackage[T1]{fontenc}
\usepackage{lmodern}
\usepackage[scaled=0.85]{beramono}

\endinput
