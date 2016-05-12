#!/bin/bash
#
# Autor: Falk Hanisch, Jons-Tobias Wamhoff
#
# getestet auf:
# Ubuntu 14.04
# Ubuntu 15.04
#
# in Kombination mit:
# TeX Live 2015
#
# Notwendige Tools:
# unzip        (Ubuntu package unzip)
#
# Vorausgesetzte LaTeX Pakete:
# fontinst (Ubuntu package texlive-font-utils)
# lmodern  (Ubuntu package lmodern)
# cm-super (Ubuntu package cm-super)
# cmbright (Ubuntu package texlive-fonts-extra)
# hfbright (Ubuntu package texlive-fonts-extra)
# iwona    (Ubuntu package texlive-fonts-extra)
#
# Benoetigte Archive (im Verzeichnis des Installationsskriptes):
# DIN_Bd_PS.zip
# Univers_PS.zip
#
# Die Installation erfolgt in Normalfall in das lokale Benutzerverzeichnis
# $TEXMFHOME. Dieses entspricht unter Linux in '~/texmf' und unter Mac OS in
# '~/Library/texmf'. Wird das Skript mit 'sudo' ausgefuehrt, erfolgt die
# systemweite Installation fuer alle Nutzer in $TEXMFLOCAL.
#
# Fuer die lokale Benutzerinstallation wird waehrend des Installationsprozesses
# geprueft, ob die Schriften mit dem Befehl 'updmap-sys' systemweit registriert
# werden koennen oder ob dies im Zweifelsfall mit 'updmap' fuer den aktuellen
# Benutzer lokal geschehen muss. Die erste Variante benoetigt Zugriffsrechte
# auf den Installationsordner der Distribution, welche im Zweifelsfall durch
# das Skript efragt werden. Wird die zweite Variante gewaehlt, wird der Befehl
# 'updmap-sys' wirkungslos und der Anwender muss ab sofort den Befehl 'updmap'
# nach Aenderungen an den systemweiten LaTeX-Schriften (z.B. Updates) manuell
# aufrufen, damit neue respektive aktualisierte Schriften registriert werden.
# Bei Mac OS kann dies automatisch mit "TeX Live Utility.app": "Preferences..."
# -> "Automatically enable fonts in my home directory." erfolgen.
#
echo
echo  =====================================================================
echo
echo   Installation TUD-KOMA-Script + TUD-CD-Schriften unter Unix
echo     2016/03/26 v2.04d TUD-KOMA-Script
echo
checkfile()
{
  if [ ! -f "$1" ] ; then
    missing=true
    missingfile "$1"
  else
    echo   Datei $1 gefunden.
  fi
}
missingfile()
{
  echo  =====================================================================
  echo
  echo   Die Datei $1 wurde nicht gefunden. Diese wird fuer die
  echo   Installation zwingend benoetigt. Bitte kopieren Sie $1
  echo   in das Verzeichnis des Skriptes und fuehren dieses abermals aus.
  echo
  echo  =====================================================================
}
checkpackage()
{
  package=$(kpsewhich $1)
  if [ -z "$package" ] ; then
    missing=true
    missingpackage "$1" "$2"
  else
    echo   Paket $2 \($1\) gefunden.
  fi
}
missingpackage()
{
  echo  =====================================================================
  echo
  echo   Das LaTeX-Paket $2 \($1\) wurde nicht gefunden.
  echo   Dieses wird fuer die Schriftinstallation zwingend benoetigt.
  echo   Bitte das Paket \'$2\' ueber die Distribution installieren und
  echo   danach dieses Skript abermals ausfuehren.
  echo
  echo  =====================================================================
}
checkscript()
{
  script=$(which $1)
  if [ -z "$script" ] ; then
    missing=true
    missingscript "$1" "$2"
  else
    echo   Skript $1 aus Paket $2 gefunden.
  fi
}
missingscript()
{
  echo  =====================================================================
  echo
  echo   Das ausfuehrbare Skript $1 aus dem Paket $2 wurde nicht
  echo   gefunden. Dieses wird im Normalfall von der LaTeX-Distribution
  echo   bereitgestellt und zur Schriftinstallation zwingend benoetigt.
  echo   Bitte das Paket \'$2\' ueber die Distribution installieren und
  echo   danach dieses Skript abermals ausfuehren.
  echo
  echo  =====================================================================
}
proof_userinput()
{
  echo
  echo  =====================================================================
  echo
  echo   $texmfpath
  echo
  echo   Soll dieser Pfad genutzt werden?
  if [ ! -d $texmfpath ] ; then
    echo   Der angegebene Ordner existiert nicht, wird jedoch erstellt.
  fi
  select yn in "Ja (empfohlen)" "Nein"; do
    case $yn in
      "Ja (empfohlen)") break;;
      "Nein")
        set_texmfpath
        break;;
    esac
  done
}
set_texmfpath()
{
  echo
  echo   Geben Sie das Installationsverzeichnis an:
  read texmfpath
  proof_userinput
}
mkvaldir()
{
  mkdir -p $1
  if [ $? -ne 0 ] ; then
    echo Keine Schreibberechtigung fuer folgenden Pfad:
    echo $1
    echo Versuchen Sie das Ausfuehren mit \'sudo -k bash <Skriptname>\'
    abort
  fi
}
abort()
{
  echo
  echo  =====================================================================
  echo   Abbruch der Installation, temporaere Dateien werden geloescht.
  echo  =====================================================================
  echo
  read -n1 -r -p "Druecken Sie eine beliebige Taste . . . "
  echo
  rm -rf tudscrtemp
  exit 0
}
texpath=$(which tex)
if [ -z "$texpath" ] ; then
  echo Es wurde keine LaTeX-Distribution gefunden.
  echo Moeglicherweise hilft der Aufruf des Skriptes mit:
  echo "'sudo -k env \"PATH=\$PATH\" bash $0'"
  abort
fi
echo
echo   LaTeX-Distribution gefunden in:
echo   \'$texpath\'
echo
echo  =====================================================================
echo
rm -rf tudscrtemp
mkvaldir tudscrtemp/converted
echo  =====================================================================
echo
echo   Notwendige Dateien und Pakete werden gesucht.
echo   Dies kann einen Moment dauern.
echo
missing=false
version="$(basename $0)"
version=$(echo $version|cut -c8-)
version=$(echo $version|rev|cut -c12-|rev)
checkfile "tudscr_$version.zip"
checkfile "Univers_PS.zip"
checkfile "DIN_Bd_PS.zip"
checkfile "tudscr_fonts_install.zip"
if $missing ; then
  abort
fi
checkscript "pltotf"        "fontware"
checkscript "vptovf"        "fontware"
checkpackage "fontinst.sty" "fontinst"
checkpackage "type1ec.sty"  "cm-super"
checkpackage "lmodern.sty"  "lm"
checkpackage "cmbright.sty" "cmbright"
checkpackage "hfbright.map" "hfbright"
checkpackage "iwona.sty"    "iwona"
if $missing ; then
  abort
fi
echo
echo   Es wurden alle notwendigen Dateien und Pakete gefunden.
echo
echo  =====================================================================
echo  =====================================================================
echo
if [ "$EUID" -eq 0 ] ; then
  texmfpath=$(kpsewhich --var-value=TEXMFLOCAL)
  echo   Mehrbenutzerinstallation \(Administrator\).
else
  texmfpath=$(kpsewhich --var-value=TEXMFHOME)
  echo   Einzelbenutzerinstallation.
fi
echo
echo  =====================================================================
echo  =====================================================================
echo
echo   Bitte geben Sie das gewuenschte Installationsverzeichnis an.
echo   Dieses sollte sich jenseits der Distributionsordnerstruktur
if [ "$EUID" -eq 0 ] ; then
  echo   in einem Pfad mit Lese-Zugriff fuer alle Benutzer befinden.
else
  echo   in einem lokalen Benutzerpfad befinden.
fi
echo
echo   Sie sollten den voreingestellten Standardpfad verwenden.
proof_userinput
echo
echo  =====================================================================
echo   Installation in folgenden Pfad:
echo   $texmfpath
echo  =====================================================================
echo
updmapsys=true
if [ -d "$(kpsewhich --var-value=TEXMFVAR)/fonts/map/" ] ; then
  updmapsys=false
else
  texdirarray=(
    $(kpsewhich --var-value=TEXMFSYSVAR)
    $(kpsewhich --var-value=TEXMFSYSCONFIG)
    $(kpsewhich --var-value=TEXMFHOME)
  )
  looptexdirarray()
  {
    for d in "${texdirarray[@]}"; do
      if [ -d "$d" ] && [ ! -w "$d" ] ; then
        if [ "$1" == "use" ] ; then
          eval ${@:2} $d;
        else
          eval $@;
        fi
      fi
    done
  }
  texdirpermitted=false
  looptexdirarray texdirpermitted=true
  if $texdirpermitted ; then
    echo Fuer das systemweite Registrieren der Schriften ist das Ausfuehren
    echo von \'updmap-sys\' erforderlich. Dazu muessen fuer die nachfolgend
    echo aufgelisteten Ordner fuer alle anderen Benutzer \(\'other\'\) mit
    echo \'sudo chmod -R o+w\' Schreibrechte gesetzt werden. Dieses Vorgehen
    echo wird empfohlen.
    echo
    looptexdirarray use echo
    echo
    echo Andernfalls wird lediglich \'updmap\' aufgerufen, wodurch der Befehl
    echo \'updmap-sys\' ab diesem Zeitpunkt wirkungslos wird und der Anwender
    echo ab sofort nach Aenderungen an den LaTeX-Schriften \(z.B. Updates\)
    echo den Befehl \'updmap\' manuell aufrufen muss, damit neue repsektive
    echo aktualisierte Schriften registriert werden.
    select yn in "Schreibrechte setzen (empfohlen)" "'updmap' verwenden"; do
      case $yn in
        "Schreibrechte setzen (empfohlen)")
          looptexdirarray use sudo chmod -R o+w
          sudo -k
          texdirpermitted=false
          looptexdirarray texdirpermitted=true
          if $texdirpermitted ; then
            echo
            echo Setzen der Schreibrechte gescheitert!
            abort
          fi
          break;;
        "'updmap' verwenden")
          updmapsys=false
          break;;
      esac
    done
  fi
fi
localfolder=tudscr
mkvaldir $texmfpath/tex/latex/$localfolder/fonts
mkvaldir $texmfpath/fonts/tfm/$localfolder
mkvaldir $texmfpath/fonts/afm/$localfolder
mkvaldir $texmfpath/fonts/vf/$localfolder
mkvaldir $texmfpath/fonts/type1/$localfolder
mkvaldir $texmfpath/fonts/map/dvips/$localfolder
unzip -o tudscr_$version.zip -d $texmfpath
unzip Univers_PS.zip -d tudscrtemp
unzip DIN_Bd_PS.zip -d tudscrtemp
unzip tudscr_fonts_install.zip -d tudscrtemp/converted
cd tudscrtemp
cp uvcel___.pfb converted/lunl8a.pfb
cp uvcel___.afm converted/lunl8a.afm
cp uvxlo___.pfb converted/lunlo8a.pfb
cp uvxlo___.afm converted/lunlo8a.afm
cp uvce____.pfb converted/lunr8a.pfb
cp uvce____.afm converted/lunr8a.afm
cp uvceo___.pfb converted/lunro8a.pfb
cp uvceo___.afm converted/lunro8a.afm
cp uvceb___.pfb converted/lunb8a.pfb
cp uvceb___.afm converted/lunb8a.afm
cp uvxbo___.pfb converted/lunbo8a.pfb
cp uvxbo___.afm converted/lunbo8a.afm
cp uvcz____.pfb converted/lunc8a.pfb
cp uvcz____.afm converted/lunc8a.afm
cp uvczo___.pfb converted/lunco8a.pfb
cp uvczo___.afm converted/lunco8a.afm
cp DINBd___.pfb converted/0m6b8a.pfb
cp DINBd___.afm converted/0m6b8a.afm
echo
echo  =====================================================================
echo   Virtuelle Schriften erzeugen. \(Dies kann einen Moment dauern\)
echo  =====================================================================
echo
cd converted
echo 00/19
tftopl cmbr10.tfm cmbr10.pl
echo 01/19
tftopl cmbrsl10.tfm cmbrsl10.pl
echo 02/19
tftopl cmbrbx10.tfm cmbrbx10.pl
echo 03/19
tftopl tbmr10.tfm tbmr10.pl
echo 04/19
tftopl tbmo10.tfm tbmo10.pl
echo 05/19
tftopl tbsr10.tfm tbsr10.pl
echo 06/19
tftopl tbso10.tfm tbso10.pl
echo 07/19
tftopl tbbx10.tfm tbbx10.pl
echo 08/19
tftopl cmbrmi10.tfm cmbrmi10.pl
echo 09/19
tftopl cmbrmb10.tfm cmbrmb10.pl
echo 10/19
tftopl cmbrsy10.tfm cmbrsy10.pl
echo 11/19
tftopl sy-iwonamz.tfm sy-iwonamz.pl
echo 12/19
tftopl sy-iwonahz.tfm sy-iwonahz.pl
echo 13/19
tftopl rm-iwonach.tfm rm-iwonach.pl
echo 14/19
tftopl rm-iwonachi.tfm rm-iwonachi.pl
echo 15/19
tftopl ts1-iwonach.tfm ts1-iwonach.pl
echo 16/19
tftopl ts1-iwonachi.tfm ts1-iwonachi.pl
echo 17/19
tftopl mi-iwonachi.tfm mi-iwonachi.pl
echo 18/19
tftopl sy-iwonachz.tfm sy-iwonachz.pl
echo 19/19
latex installfonts.tex
for f in $(ls *.pl) ; do
  pltotf $f
done
for f in $(ls *.vpl) ; do
  vptovf $f
done
latex createmap.tex
echo
echo  =====================================================================
echo   Konvertierung abgeschlossen.
echo  =====================================================================
echo
cp -f *.fd  $texmfpath/tex/latex/$localfolder/fonts
cp -f *.tfm $texmfpath/fonts/tfm/$localfolder
cp -f *.afm $texmfpath/fonts/afm/$localfolder
cp -f *.vf  $texmfpath/fonts/vf/$localfolder
cp -f *.pfb $texmfpath/fonts/type1/$localfolder
cp -f *.map $texmfpath/fonts/map/dvips/$localfolder
texhash
if $updmapsys || [ "$EUID" -eq 0 ] ; then
  echo  =====================================================================
  echo   Aufruf von \'updmap-sys\'
  echo  =====================================================================
  updmap-sys --enable Map=tudscr.map --force
fi
if ! $updmapsys ; then
  echo  =====================================================================
  echo   Aufruf von \'updmap\'
  echo  =====================================================================
  updmap --enable Map=tudscr.map --force
fi
echo
echo  =====================================================================
echo   Die Installation wird beendet.
echo   Der Ordner mitsamt aller temporaeren Dateien wird geloescht.
echo  =====================================================================
echo   Dokumentation und Beispiele fuer das TUD-KOMA-Script-Bundle sind
echo   unter $texmfpath/doc/latex/tudscr oder
echo   ueber den Terminalaufruf \'texdoc tudscr\' zu finden.
echo  =====================================================================
cd ../..
read -n1 -r -p "Druecken Sie eine beliebige Taste . . . "
echo
rm -rf tudscrtemp
exit 0
