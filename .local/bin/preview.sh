
#!/usr/bin/env bash
# Dependencies: chafa

# Determine input: file or stdin
if [[ -n "$1" && -f "$1" ]]; then
    file="$1"
elif ! [ -t 0 ]; then
    # stdin is not a TTY → read into temp file
    tmpfile=$(mktemp /tmp/preview.XXXXXX)
    cat - > "$tmpfile"
    file="$tmpfile"
else
    >&2 echo "Usage: $0 FILENAME or pipe binary data into stdin"
    exit 1
fi

# Resolve tilde in path
file=${file/#\~\//$HOME/}

type=$(file --brief --dereference --mime -- "$file")

if [[ ! $type =~ image/ ]]; then
    if [[ $type =~ application/pdf ]]; then
        pdftotext -l 1 "$file" - | head -n 40
        exit
    elif [[ $type =~ binary ]]; then
        file "$file"
        exit
    else
        cat "$file"
        exit
    fi
fi

# Determine preview dimensions
dim=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}
if [[ $dim = x ]]; then
    dim=$(stty size < /dev/tty | awk '{print $2 "x" $1}')
elif (( FZF_PREVIEW_TOP + FZF_PREVIEW_LINES == $(stty size < /dev/tty | awk '{print $1}') )); then
    dim=${FZF_PREVIEW_COLUMNS}x$((FZF_PREVIEW_LINES - 1))
fi

# Show image preview
if command -v chafa > /dev/null; then
    chafa -s "$dim" "$file"
else
    file "$file"
fi

# Clean up temp file if used
if [[ -n "$tmpfile" ]]; then
    rm -f "$tmpfile"
fi
