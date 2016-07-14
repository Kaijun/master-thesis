#!/bin/bash
pdflatex Graphical-Discussion-System
makeglossaries Graphical-Discussion-System
bibtex Graphical-Discussion-System 
pdflatex Graphical-Discussion-System
