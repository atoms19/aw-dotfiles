#!/usr/bin/env bash
# Dependencies:
# - https://github.com/hpjansson/chafa

if [[ $# -ne 1 ]]; then
  >&2 echo "usage: $0 FILENAME[:LINENO][:IGNORED]"
  exit 1
fi

file=${1/#\~\//$HOME/}


type=$(file --brief --dereference --mime -- "$file")

if [[ ! $type =~ image/ ]]; then
 if [[ $type =~ application/pdf ]]; then 
	 pdftotext -l 1 "$file" - | head -n 40
	 exit
  
  elif [[ $type =~ =binary ]]; then
    file "$1"
    exit
 else 
   cat "$1"
    exit
  fi
fi

dim=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}
if [[ $dim = x ]]; then
  dim=$(stty size < /dev/tty | awk '{print $2 "x" $1}')
elif (( FZF_PREVIEW_TOP + FZF_PREVIEW_LINES == $(stty size < /dev/tty | awk '{print $1}') )); then
  dim=${FZF_PREVIEW_COLUMNS}x$((FZF_PREVIEW_LINES - 1))
fi

if command -v chafa > /dev/null; then
   chafa -s "$dim" "$file"
else
  file "$file"
fi
