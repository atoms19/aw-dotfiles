# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e

# End of lines configured by zsh-newuser-install
alias awa="ollama run dolphin3:8b-llama3.1-q4_K_M"
# The following lines were added by compinstall
alias vi=nvim 
zstyle :compinstall filename '/home/atoms/.zshrc'
autoload -Uz compinit

alias rain="python ~/.local/share/rain/terminal_rain_lightning.py"
compinit
# End of lines added by compinstall
#
setopt PROMPT_SUBST


zstyle ':vcs_info:git:*' formats '(  %b )'
PROMPT='%n ${PWD/#$HOME/}${vcs_info_msg_0_}> '

lfcd () {
  tmp="$(mktemp)"
  lf -last-dir-path="$tmp" "$@"
  if [ -f "$tmp" ]; then
    dir="$(cat "$tmp")"
    rm -f "$tmp"
    cd "$dir"
  fi
}

alias java="_JAVA_AWT_WM_NONREPARENTING=1 java"
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
fcd() {
  local dir
  dir=$( fd --type d --hidden | fzf --height=40% --reverse --preview 'ls -la {}' --query="$1") && cd "$dir"
}
# pnpm
fcf() {
  local file filetype
  file=$(fd --type f --hidden --exclude .git | fzf --height=40% --reverse --preview '~/.local/bin/preview.sh {}' --query="$1") || return

  filetype="$(file -b --mime-type "$file")"

  case "$filetype" in
    "application/pdf")
		setsid zathura "$file" >/dev/null 2>&1 < /dev/null & ;;
    "text/"*|application/json|application/xml|application/javascript)
		cd "$(dirname "$file")" || return
		nvim "$(basename "$file")" ;;
    "image/"*)
      chafa "$file" ;;
    "video/"*)
		setsid mpv "$file" >/dev/null 2>&1 < /dev/null & ;;
    *)
      echo "No handler for filetype: $filetype"
      read -p "Open with vim anyway? [y/N] " ans
      [[ "$ans" =~ ^[Yy]$ ]] && nvim "$file"
      ;;
  esac
}
export PNPM_HOME="/home/atoms/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# bun completions
[ -s "/home/atoms/.bun/_bun" ] && source "/home/atoms/.bun/_bun"

# bun
export PATH="$HOME/.local/bin:$PATH"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
export GTK_ICON_THEME=Papirus-Dark
export XCURSOR_THEME=Papirus
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
