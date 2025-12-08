#!/bin/sh

XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share:$HOME/.local/share/applications}"
XDG_DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
USAGE_LOG="$XDG_DATA_HOME/recentlyused.log"

[ -d "$XDG_DATA_HOME" ] || mkdir -p "$XDG_DATA_HOME"
[ -f "$USAGE_LOG" ] || touch "$USAGE_LOG"

app_dirs="$XDG_DATA_HOME/applications"
IFS=:
for dir in $XDG_DATA_DIRS; do
    app_dirs="$app_dirs
$dir/applications"
done

temp_sorted=$(mktemp)
trap 'rm -f "$temp_sorted"' EXIT

printf '%s\n' "$app_dirs" | sed '1d' | \
gawk -v usage_log="$USAGE_LOG" '
BEGIN {
    while ((getline line < usage_log) > 0) {
        if (split(line, parts, " ") >= 2) {
            count[parts[2]] = parts[1]
        }
    }
    close(usage_log)

    RS = "\n"
}
{
    if (length($0) > 0 && system("[ -d \"" $0 "\" ]") == 0) {
        cmd = "find \"" $0 "\" -maxdepth 1 -name \"*.desktop\" -print 2>/dev/null"
        while ((cmd | getline file) > 0) {
            if (file in processed) continue
            processed[file] = 1

            valid = 0; hidden = 0; name = ""
            while ((getline line < file) > 0) {
                gsub(/\r/, "", line)
                if (line == "[Desktop Entry]") {
                    valid = 1
                } else if (valid && (line ~ /^Hidden=true/ || line ~ /^NoDisplay=true/)) {
                    hidden = 1
                    break
                } else if (valid && name == "" && line ~ /^Name=/) {
                    match(line, /^Name=(.*)/, m)
                    name = m[1]
                }
            }
            close(file)

            if (valid && !hidden && name != "") {
                c = (file in count) ? count[file] : 0
                printf "%010d\t%s\t%s\n", c, name, file
            }
        }
        close(cmd)
    }
}' | sort -k1,1nr > "$temp_sorted"

if [ ! -s "$temp_sorted" ]; then
    echo "no applications found" >&2
    exit 1
fi

selected=$(awk -F'\t' '{print $2 "\t" $3}' "$temp_sorted" | \
    fzf --prompt='apps> ' --height=100% --reverse --with-nth=1 --delimiter=$'\t')

if [ -n "$selected" ]; then
    IFS=$'\t' read -r name file << EOF
$selected
EOF

    nohup dex --term foot "$file" >/dev/null 2>&1 &

    tmp_log=$(mktemp)
    gawk -v f="$file" '
        $2 != f { print }
        END {
            old = 0
            while ((getline line < "'"$USAGE_LOG"'") > 0) {
                if (line ~ "^ *[0-9]+ " f "$") {
                    split(line, p, " ")
                    old = p[1]
                    break
                }
            }
            close("'"$USAGE_LOG"'")
            print (old + 1) " " f
        }
    ' "$USAGE_LOG" > "$tmp_log"
    mv "$tmp_log" "$USAGE_LOG"
fi
