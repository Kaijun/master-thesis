%%****************************************
%%*                                      *
%%* TU Dresden                           *
%%* Lehrstuhl für Wirtschaftsinformatik, *
%%* insbesondere Systementwicklung       *
%%*                                      *
%%****************************************
%%
%% LaTeX-Vorlage fuer Doktor-, Diplom-, Bachelor-, Master- und Seminararbeiten
%% Hauptteil
%%
%% Version: 1.0  Neuversionierung (Malte Helmhold, 07/10/2012) 

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{wise}[10/07/2012 Vorlage fuer Dokumente an der WiSe von 
Malte Helmhold]
\LoadClass[clearpage=empty, listof=totoc,  bibliography=totoc, index=totoc, 11pt, abstracton, numbers=noenddot]{scrartcl}

% Quellcode darstellen
\RequirePackage{listings}
\RequirePackage{fancyvrb}
\RequirePackage{amsmath}

\def\arraystretch{1.5}



% Absolute Position mit dem Parameter [H] erzwingen bei figure und table Umgebung durch float: 
\RequirePackage{float}

%Auswertung der Paketoptionen
%Behandlung der pdf-Option. Dies wird eingeführt, um Übersetzungszeit
%zu sparen, wenn nur ein .ps erzeugt werden soll.
\newif\if@pdf
\@pdffalse
\DeclareOption{pdf} {%
    \@pdftrue%
}%

  % de Sprachoption für englische Vorlage
 \newif\if@en
\@enfalse
\DeclareOption{en} {%
 \@entrue%
 }%

%natbib Literaturverzeichnis erzeugen mit wisenat
\newif\if@nat
\@pdffalse
\DeclareOption{nat} {%
    \@nattrue%
}%
%ngerman-Option verarbeiten
\newif\if@ngerman
\@ngermanfalse
\DeclareOption{ngerman}{%
  \@ngermantrue%
}%
%mp-Option verarbeiten
\newif\if@mp
\@mpfalse
\DeclareOption{mp}{%
  \@mptrue%
}%
%mppdf-Option verarbeiten; pdf-Option mit einschalten.
\newif\if@mppdf
\@mppdffalse
\DeclareOption{mppdf}{%
  \@mppdftrue%
  \@pdftrue%
}%
% Option für eine vierte numerierte Gliederungsebene
\newif\if@xlevel
\@xlevelfalse
\DeclareOption{xlevel}{%
   \@xleveltrue
}
% Option zum Einsatz des Hyperref Paketes
\newif\if@hyperref
\@hyperreffalse
\DeclareOption{hyperref}{%
  \@hyperreftrue
}
%Option für die veränderte Kopfzeilenbeschriftung
\newif\if@partmarking
\@partmarkingfalse
\DeclareOption{partmarking}{%
  \@partmarkingtrue
}





%Alle uebrigen Optionen werden an scrartcl weitergereicht
\DeclareOption*{%
    \typeout{Option \CurrentOption\space is passed to package scrartcl!}
    \PassOptionsToPackage{\CurrentOption}{scrartcl}
}%
\ProcessOptions\relax

%Seitenaufteilung festlegen.
\RequirePackage{geometry}
\RequirePackage{color}

% Kommentierte LaTeX Umgebung erschaffen. 
\definecolor{lightgrey}{rgb}{0.9,0.9,0.9}
\definecolor{darkgreen}{rgb}{0,0.6,0}

\newcommand{\lstlatex}{\lstset{language=[LaTeX]TeX,
texcsstyle=*\bf\color{blue},
numbers=none,
breaklines=true,
keywordstyle=\color{darkgreen},
commentstyle=\color{red},
%otherkeywords={$, \{, \}, \[, \]},
frame=none,
tabsize=2,
%backgroundcolor=\color{lightgrey},
%caption=LaTeX example
}
}


\newcommand\@normalgeometry{%
  \geometry{a4paper, tmargin=10mm,bmargin=30mm,lmargin=24mm,rmargin=35mm,
    headheight=15mm,headsep=7mm,ignorefoot,includehead}
}
\newcommand\@mpgeometry{%
  \geometry{a4paper,tmargin=10mm,bmargin=30mm,lmargin=28mm,rmargin=35mm,%
    headheight=15mm,headsep=7mm,ignorefoot,includehead}%
  \setlength{\marginparsep}{5mm}
}
\newcommand\@mppdfgeometry{%
  \geometry{a4paper,tmargin=10mm,bmargin=30mm,lmargin=28mm,rmargin=35mm,%
    headheight=15mm,headsep=7mm,ignorefoot,includehead}%
  \setlength{\marginparsep}{10mm}
}

%Fuer die mp bzw. mppdf wird eine andere Seitenaufteilung
%vereinbart
\if@mp%
  %Seitenaufteilung mit Randnotizen
  \@mpgeometry
\else
  \if@mppdf%
    %Seitenaufteilung fuer Randnotizen und pdf
    \@mppdfgeometry
  \else
    %normale Seitenaufteilung
    \@normalgeometry
  \fi
\fi

%Option nat auswerten und natbib Package einbinden für wisenat. Ohne diese Option muss die alte wisealpha.bst benutzt werden. 
\if@nat%
\RequirePackage{natbib}
\fi

% Wenn wir ein pdf erzeugen, dann für das Inhaltsverzeichnis
% ein bookmark einfügen
\if@pdf\if@hyperref
  \let\@tableofcontents\tableofcontents
  \renewcommand\tableofcontents{%
    \hypertarget{tableofcontents.1}{}%
    \pdfbookmark[1]{Inhaltsverzeichnis}{tableofcontents}%
    \@tableofcontents%
  }
\fi\fi

\if@en%
\RequirePackage[ngerman, english]{babel}%
\fi

%Neudeutsch laden
\if@ngerman%
\RequirePackage{ngerman}%
\fi
%Da man bei Neudeutsch ebenfalls Zitate in Altdeutsch haben wird,
%Wird das german-Paket auf jeden Fall benoetigt.
\RequirePackage{german}

% Veränderungen in der Gliederungsebene (Einführung einer vierten numerierten
% Ebene)
% Dabei werden die Schriftarten des Paragraphen auf die Normalgröße
% reduziert. Der subparagraph wird dann schräg gesetzt.
\if@xlevel
\setcounter{secnumdepth}{4}
\setcounter{tocdepth}{4}
\fi

%Große Überschriften beginnen stets auf einer neuen Seite, dessen Stil
%empty ist
\addtokomafont{section}{\clearpage\thispagestyle{empty}}

%Abschnitte beginnen auf einer neuen Doppelseite mit leerem Stil und
%2cm vom oberen Rand entfernt
\addtokomafont{partnumber}{\cleardoublepage\thispagestyle{empty}\vspace*{4cm}}
% Festlegen der neuen Schriftarten für den Paragraphen und den
% Subparagraphen.
\setkomafont{paragraph}{\normalcolor\sffamily\bfseries}
\setkomafont{subparagraph}{\normalcolor\sffamily\slshape}

\RequirePackage[latin9]{inputenc}
\RequirePackage{times}

\RequirePackage{graphicx}
\RequirePackage{url}



%Zeilenabstand 1.5-zeilig
\RequirePackage[onehalfspacing]{setspace}

%Kopfzeile einblenden mit vernünftiger Formatierung (keine
%Silbentrennung und Begrenzung der Textlaufweite
\RequirePackage[headsepline, automark]{scrpage2}
%Wir schalten sämtliche Anhänge erst mal aus
\clearscrheadings\clearscrplain

\ohead{\pagemark}\ihead{\scshape\headmark}\chead{}
%Zeichensätze der Kopfzeile setzen
\setkomafont{pageheadfoot}{%
 	\normalfont
}
\setkomafont{pagenumber}{\normalfont}
%Nummerierung in der Kopfzeile ausblenden
\renewcommand\sectionmarkformat{}
\renewcommand\subsectionmarkformat{}

%Falls die Teilemarkierung in die Kopfzeile soll, müssen wir
%etwas umständlicher verfahren, da das scrpage2-Paket die Option
%\automark{part} nicht kennt. Wir müssen das also manuell
%bewerkstelligen.
%Dazu definieren wir einfach das subsectionmark um.
\if@partmarking
%Subsectionmark so umschreiben, dass es nun die Teilmarkierung aufnimmt.
\renewcommand{\subsectionmark}[1]{\markright{\partmark}}
%Teilmarkierung initial definieren
\newcommand\partmark{}
%Den part-Befehl kopieren
\let\@my@part\@part
%Und redefinieren, um dabei die rechte Kopfzeile markieren zu können.
\def\@part[#1]#2{
  \@my@part[#1]{#2}
  \def\partmark{#1}
}
\fi
%Kopfzeile einschalten
\pagestyle{scrheadings}

%%Anhaenge einbauen
\RequirePackage[header, title, toc]{wiseapp}
\renewcommand{\appendixtocname}{Anh\"ange}

%Für den Vorspann des Werkes, bitte folgende Umgebung nutzen:
\newenvironment{preface}{%
  \cleardoublepage
  \thispagestyle{empty}
  \pagenumbering{Roman}
}{%
  \cleardoublepage
  \thispagestyle{empty}
  \pagenumbering{arabic}
}

%Zusatzbefehle------------------------------------------
%
%Einleitung. Beginnt mit Punkt 0 und  ab hier gilt die arabische Nummerierung
\if@en%
\newcommand\introduction{%
  \setcounter{section}{0}%
  %\section{Introduction}%
}%
\else
\newcommand\introduction{%
\setcounter{section}{0}%
\section{Einleitung}%
}%
\fi%



%Abkürzungsverzeichnis

\if@en%
\newcommand\listofabbreviations{%
  \addsec{List of Abbreviations}%
}%
\else
\newcommand\listofabbreviations{%
  \addsec{Abkürzungsverzeichnis}%
}%
\fi%

%Befehl für eine Abkürzung
\newcommand\abbreviation[2]{
  \noindent%
  \setlength{\tabcolsep}{0pt}%
  \begin{tabular}{p{4.5cm}p{10cm}}
    #1 & #2 \\
  \end{tabular}
  \newline
}

%Zum Einbinden von Mehrzeiligen Kommentaren mit \begin{comment} Umgebung
\RequirePackage{verbatim}

%Umgebung Laden für \being{lstlisting} für die Ausgabe mehrzeilgen Quellcodes
\RequirePackage{listings}


%Kommando zum zitieren von ([FeSi1994], S.12)
%\newcommand\shortcite[2] {(\cite{#1}, S.~#2)}
%Kommando zum Zitieren von (vgl. [FeSi1994], S.15)
%\newcommand\longcite[2] {(vgl.~\cite{#1}, S.~#2)}
%Kommando zum Zitieren von (vgl. [FeSi1994], S.15 f.)
\newcommand\longcitef[2] {(vgl.~\cite{#1}, S.~#2 f.)}
%Kommando zum Zitieren von (vg. [FeSi1994], S.15 ff.)
\newcommand\longciteff[2] {(vgl.~\cite{#1}, S.~#2 ff.)}
%Kommando zum zitieren von ([FeSi1994], S.12 f.)
\newcommand\shortcitef[2] {(\cite{#1}, S.~#2 f.)}
%Kommando zum zitieren von ([FeSi1994], S.12 ff.)
\newcommand\shortciteff[2] {(\cite{#1}, S.~#2 ff.)}
%versuch
\newcommand\opt[3][] {(\cite{#2}, S.~#3#1)}
%Shortcite mit optionalem Parameter Kommando zum zitieren von
% ([FeSi1994], S.12 f.) ODER ([FeSi1994], S.12 ff.) durch \shortcite[, ff.]{Citekey}{Seite}
\newcommand\shortcite[3][] {(\cite{#2}, S.~#3#1)}
\newcommand\longcite[3][] {(vgl. ~\cite{#2}, S.~#3#1)}
%\newcommand\zitn[3]

%indirect und direct citation:  (wie shortcite longcite nur verständlicher)
\newcommand\indirect[2] {(vgl.~\cite{#1}, S.~#2)}
\newcommand\indirectf[2] {(vgl.~\cite{#1}, S.~#2 f.)} 
\newcommand\indirectff[2] {(vgl.~\cite{#1}, S.~#2 ff.)}
\newcommand\direct[2] {(\cite{#1}, S.~#2)}
\newcommand\directf[2] {(\cite{#1}, S.~#2 f.)}
\newcommand\directff[2] {(\cite{#1}, S.~#2 ff.)}
\newcommand\citepages[3] {(vgl. \cite{#1}, S.~#2--#3)}
\newcommand\vgl[1] {(vgl.~\cite{#1})}
\newcommand\urlcite[1] {(\cite{#1})}




%Zusatzbefehle fuer erweiterte Boxen fuer die roemischen Zahlen
%Da diese Befehle auch in tocloft definiert werden, schreiben wir
%einfach 'wise' davor.
\newcommand{\wisecftsetpnumwidth}[1]{%
    \renewcommand{\@pnumwidth}{#1}
}
\newcommand{\wisecftsetrmarg}[1]{%
    \renewcommand{\@tocrmarg}{#1}
}
\newcommand{\wisecftlocalchange}[3]{%
    \addtocontents{#1}{\protect\wisecftsetpnumwidth{#2}
        \protect\wisecftsetrmarg{#3}}
}    

%Standardmaessig formatieren wir die Herausgeber eines Werkes mal
%fett. Wer will, kann diesen Befehl einfach überschreiben und damit
%den Default außer Kraft setzen.
\newcommand{\empheditors}[1]{
  \textbf{#1}
}

%Redefinitionen-----------------------------------------
%
% Paragraphen und Subparagraphen werden wie eine Überschrift gesetzt
% und nicht, wie im LaTeX-Standard in den Text integriert.
\renewcommand\paragraph{\@startsection{paragraph}{4}{\z@}%
  {-2ex\@plus -1ex \@minus -.2ex}%
  {1.5ex \@plus .2ex}%
  {\raggedsection\normalfont\sectfont\nobreak\size@paragraph\nobreak}}

\renewcommand\subparagraph{\@startsection{subparagraph}{5}{\z@}%
  {-2ex\@plus -1ex \@minus -.2ex}%
  {1.5ex \@plus .2ex}%
  {\raggedsection\normalfont\sectfont\nobreak\size@subparagraph\nobreak}}

%Abbildungs- & Tabellenverzeichnisse sollen ganz links beginnen.
\renewcommand*\l@figure{\@dottedtocline{1}{0em}{2.3em}}

%Literaturverzeichnis statt nur Literatur
\renewcommand{\refname}{Literaturverzeichnis}

%Seitenstil der Indexumgebung auf empty zurücksetzen (Standard: plain!)
\renewcommand{\indexpagestyle}{empty}

%Formatierung der Randnotizen, falls ueber die mp oder
%mppdf-Option aktiviert. Anosnsten bleibt der Befehl
%ohne Wirkung
\setlength{\marginparwidth}{1.5cm}
%Umschreiben des \marginpar-Befehls
\let\@mymarginpar\marginpar
\renewcommand\marginpar[1] {%
  \if@mp%
  \@mymarginpar[\raggedleft{\vspace{1em}\tiny#1}]{\raggedright \vspace{1em}\tiny#1}
%  \marginline{\vspace{1em}\tiny#1}
  \fi%
}

%Umgebungen------------------------------------
%Abstract Befehl bereitstellen. Ab hier kleine römische Seitennumerrierung
\renewenvironment{abstract}{%
  \section*{Abstract}%
  \pagestyle{empty}
  \setcounter{page}{0}
}{%
  \pagestyle{scrheadings}
  \setcounter{page}{0}
}

%Dann gibt es die entsprechende Umgebung
%Nummerierung Roman, danach wieder arabic
\renewenvironment{appendix}{%
  \cleardoublepage
  %\pagenumbering{Roman}
  %Vergroesserung des Platzes fuer Seitenzahlen
  \wisecftlocalchange{toc}{4em}{5em}
  \wisecftlocalchange{lof}{4em}{5em}
  \wisecftlocalchange{lot}{4em}{5em}
}{%
  %%Urspruegliche Breiten einstellen
  \wisecftlocalchange{toc}{1.55em}{2.55em}
  \wisecftlocalchange{lof}{1.55em}{2.55em}
  \wisecftlocalchange{lot}{1.55em}{2.55em}
  \cleardoublepage
}



%Auswertung der Hyperref Option
\if@hyperref%
    \if@pdf
        % PDF Option eingeschaltet -> Entsprechenden Backend Treiber für
        % Hyperref laden
        \AtEndOfPackage{
        \RequirePackage[pdftex,colorlinks=true, linkcolor=black, urlcolor=black,
            citecolor=black]{hyperref} 
         }
     \else
        % Keine PDF Option -> Standardtreiber für dvips laden
        \AtEndOfPackage{
        \RequirePackage[colorlinks=true, linkcolor=black, urlcolor=black,
            citecolor=black]{hyperref} 
        }
     \fi
\fi%

%für das schönere Umbrechen von URL's im Literaturverzeichnis. Siehe URL-Package Dokumentation
\g@addto@macro\UrlBreaks{ \do\a\do\b\do\c\do\d\do\e\do\f\do\g\do\h\do\i\do\j \do\k\do\l\do\m\do\n\do\o\do\p\do\q\do\r\do\s\do\t \do\u\do\v\do\w\do\x\do\y\do\z\do\&\do\1\do\2\do\3 \do\4\do\5\do\6\do\7\do\8\do\9\do\0} 


\if@en%
      \RequirePackage{wisetextEN}
     \else
       \RequirePackage{wisetextDE}
     \fi%
