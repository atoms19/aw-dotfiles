#!/bin/sh

XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share:$HOME/.local/share:/usr/share}"
USAGE_LOG="$XDG_DATA_HOME/recentlyused.log"



[ -d "$XDG_DATA_HOME" ] || mkdir -p "$XDG_DATA_HOME"
[ -f "$USAGE_LOG" ] || touch "$USAGE_LOG"

app_dirs="$XDG_DATA_HOME/applications"
IFS=:
for dir in $XDG_DATA_DIRS; do
    app_dirs="$app_dirs
$dir/applications"
done

temp_entries=$(mktemp)
temp_sorted=$(mktemp)
trap 'rm -f "$temp_entries" "$temp_sorted"' EXIT

{
    printf '%s\n' "$app_dirs" | sed '1d' | while IFS= read -r dir; do
        [ -d "$dir" ] && find "$dir" -maxdepth 2 -name '*.desktop' -print
    done
} | awk -v usage_log="$USAGE_LOG" '
function is_valid(file) {
    hidden = 0; name = ""; valid = 0
    while ((getline line < file) > 0) {
        if (line == "[Desktop Entry]") valid = 1
        else if (index(line, "Hidden=true") == 1 || index(line, "NoDisplay=true") == 1) hidden = 1
        else if (index(line, "Name=") == 1 && name == "") {
            sub(/^[^=]*=/, "", line); name = line
        }
    }
    close(file)
    return (valid && !hidden && name != "") ? name : ""
}

BEGIN {
    while ((getline < usage_log) > 0) {
        if (NF >= 2) count[$2] = $1
    }
    close(usage_log)
}

{
    n = is_valid($0)
    if (n != "") {
        c = ($0 in count) ? count[$0] : 0
        printf "%010d\t%s\t%s\n", c, n, $0
    }
}' > "$temp_entries"

[ ! -s "$temp_entries" ] && { echo "no applications found" >&2; exit 1; }

sort -k1,1nr "$temp_entries" > "$temp_sorted"
# cat "$temp_sorted"


selected=$(awk -F'\t' '{print $2 "\t" $3}' "$temp_sorted" | \
    fzf --prompt='Launch: ' --height=40% --reverse --with-nth=1 --delimiter=$'\t')

if [ -n "$selected" ]; then
    IFS=$'\t' read -r name file << EOF
$selected
EOF

    nohup dex "$file" > /dev/null 2>&1 &

    tmp_log=$(mktemp)
    awk -v f="$file" '$2 != f { print }' "$USAGE_LOG" > "$tmp_log"
    old=$(awk -v f="$file" '$2 == f {print $1}' "$USAGE_LOG")
    new=$(( ${old:-0} + 1 ))
    echo "$new $file" >> "$tmp_log"
    mv "$tmp_log" "$USAGE_LOG"
fi
