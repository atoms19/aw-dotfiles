cliphist list | fzf --height 40% --prompt "Clipboard: " --reverse --preview 'echo {} | awk "{print$1}" | cliphist decode | ~/.local/bin/preview.sh ' |   cliphist decode | wl-copy
