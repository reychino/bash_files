#Add to ~/.bashrc: source path_of_tis_file/functions.sh


#COUNTCLM
#FUNCTION TO COUNT THE NUMBER OF COLUMNS IN A FILE
function countclm {
  if [ -z "$1" ]; then
    echo -e "Select a file to count the number of columns"  
  else
    awk '{print NF}' "$1" | sort -nu | tail -n 1
  fi
}

###############################################################################

#EXTRACT
#FUNCTION TO EXTRACT COMPRESSED FILES
function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
 else
    if [ -f $1 ] ; then
        # NAME=${1%.*}
        # mkdir $NAME && cd $NAME
        case $1 in
          *.tar.bz2)   tar xvjf ../$1    ;;
          *.tar.gz)    tar xvzf ../$1    ;;
          *.tar.xz)    tar xvJf ../$1    ;;
          *.lzma)      unlzma ../$1      ;;
          *.bz2)       bunzip2 ../$1     ;;
          *.rar)       unrar x -ad ../$1 ;;
          *.gz)        gunzip ../$1      ;;
          *.tar)       tar xvf ../$1     ;;
          *.tbz2)      tar xvjf ../$1    ;;
          *.tgz)       tar xvzf ../$1    ;;
          *.zip)       unzip ../$1       ;;
          *.Z)         uncompress ../$1  ;;
          *.7z)        7z x ../$1        ;;
          *.xz)        unxz ../$1        ;;
          *.exe)       cabextract ../$1  ;;
          *)           echo "extract: '$1' - unknown archive method" ;;
        esac
    else
        echo "$1 - file does not exist"
    fi
fi
}

###############################################################################

#PLOTEX
#FUNCTION TO COMPILE ALL PLOTS IN $pwd COMMING FROM THE PDFLATEX GNUPOLOT TERM.

declare -a possible_options=(''  'q'  '-h')

if [ "$1" == "-h" ]; then
####Help info
  echo -e "\n\t\t GNUPLOT-LATEX, PDFLATEX & PLOTEX SCRIPT\n"
  echo -e "Usage directions: plotex [option]"
  echo -e "Argument options:\n <null>\t\tRun plotex in regular way.\n  \"-h\" \t\tOpen the plotex help menu.\n  \"-q\" \t\tRun plotex forceing pdflatex to compile quiet mode.\n\n"
  echo -e "  The plotex script works over all *-gp.tex files in actual directory:\n \t$PWD\n\n  Thinking about there could be other *.tex file(s) in this folder is the reason\nwhy only *-gp.tex files are used.\n\n  To have some you can modify the output filename in your gnuplot session/script\nor move the *.tex file(s) you want to plot to *-gp.tex file(s) and run the \nplotex command again.\n\n  The themporary files, including the *-gp.tex wll be deleted and only the\ncompiled *.pdf files will be keept.\n\n  Thanks for using my plotex script\n\t\t\t\t\tReinaldo Arturo Zapata Peña\n\t\t\t\t\treinaldo.zapata.p@gmail.com\n\t\t\t\t\thttps://github.com/reychino"
    exit 0

####Try to compile in regular way
elif [ -z "$1" ]; then
  gp_tex_files=`ls *-gp.tex 2>/dev/null`
  if [ -z "$gp_tex_files" ]; then
      echo -e "  No *-gp.tex file(s) in PWD:\n\t$PWD"
      echo -e "  Create one or more. For more info type \"plotex -h\"."
      exit 0
  else
    for i in ${gp_tex_files[@]}; do
      pdflatex $i
    done
    rm *.aux *.log *-gp-inc-eps-converted-to.pdf *-gp.tex *-gp-inc.eps
    exit 0
  fi

####Try to compile in quiet way
elif [ "$1" == -q ]; then
  gp_tex_files=`ls *-gp.tex 2>/dev/null`
  if [ -z "$gp_tex_files" ]; then
      echo -e "  No *-gp.tex file(s) in PWD:\n\t$PWD"
      echo -e "  Create one or more. For more info type \"plotex -h\"."
      exit 0
  else
    for i in ${gp_tex_files[@]}; do
      echo -e "Compiling: $i"
      pdflatex $i >/dev/null
    done
    rm *.aux *.log *-gp-inc-eps-converted-to.pdf *-gp.tex *-gp-inc.eps
    exit 0
  fi

####Check invalid options
else
  echo -e "Invalid option. For more info type: plotex -h for help."
fi  

###############################################################################

function rmtex {
if [ -z "$1" ]; then
  echo -e "Select the main file name of temporary files to remove includeing the \".\""
  exit 1
else
  files_to_remove=`ls *-eps-converted-to.pdf "$1"aux "$1"fdb_latexmk "$1"log "$1"out "$1"snm "$1"synctex.gz "$1"toc 2>/dev/null`
fi

if [ -z "$files_to_remove" ]; then
  echo -e "No temporary files to remove."
else
  for i in ${files_to_remove[@]}; do
    rm `echo $i`
    echo -e "Deleted file: '$i'"
  done
fi  
}



