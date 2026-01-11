# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000


# End of lines configured by zsh-newuser-install
alias awa="ollama run dolphin3:8b-llama3.1-q4_K_M"
# The following lines were added by compinstall
alias vi=nvim


autoload -Uz vcs_info
precmd() { vcs_info }

setopt PROMPT_SUBST
zstyle ':vcs_info:git:*' formats '%F{cyan} ( %b) %f'

PROMPT='%F{magenta}%n%f %F{13}%~%f${vcs_info_msg_0_}%F{green}>%f '
#----------------------------------
zstyle :compinstall filename '/home/atoms/.zshrc'
autoload -Uz compinit

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fpath=(/usr/share/zsh/site-functions /usr/share/zsh/functions $fpath)
compinit
alias rain="python ~/.local/share/rain/terminal_rain_lightning.py"
# End of lines added by compinstall
#
# setopt PROMPT_SUBST


# zstyle ':vcs_info:git:*' formats '(  %b )'
# PROMPT='%n ${PWD/#$HOME/}${vcs_info_msg_0_}> '
# -------------------------------------
lfcd () {
  tmp="$(mktemp)"
  lf -last-dir-path="$tmp" "$@"
  if [ -f "$tmp" ]; then
    dir="$(cat "$tmp")"
    rm -f "$tmp"
    cd "$dir"
  fi

}

fcd (){
 local dir
dir=$( fd --type d --hidden | fzf --height=40% --reverse --preview 'ls -la {}' --query="$1") && cd $dir 
}

# -----
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
		mpv "$file"
		#setsid mpv "$file" >/dev/null 2>&1 < /dev/null & ;;
		;;
		"audio/"*)
		mpv "$file"
		;;
    *)
      echo "No handler for filetype: $filetype"
      read -p "Open with vim anyway? [y/N] " ans
      [[ "$ans" =~ ^[Yy]$ ]] && nvim "$file"
      ;;
  esac
}
alias java="_JAVA_AWT_WM_NONREPARENTING=1 java"
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
# pnpm

export PNPM_HOME="/home/atoms/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# bun completions
[ -s "/home/atoms/.bun/_bun" ] && source "/home/atoms/.bun/_bun"

# bun prine
export PATH="$HOME/.local/bin:$PATH"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
export GTK_ICON_THEME=Papirus-Dark
export XCURSOR_THEME=Papirus
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
export _JAVA_AWT_WM_NONREPARENTING=1  
export XDG_CONFIG_HOME="$HOME/.config"
export FZF_DEFAULT_OPTS="--color=fg:#e0def4,hl:#569cd6,fg+:#bbaffa,bg+:#26233a,hl+:#ebbcba,info:#31748f,pointer:#31748f,marker:#f6c177,spinner:#89b4fa,header:#cba6f7"



preexec() {
    print -Pn "\e]0;$1 - zsh\a"
}

precmd() {
    print -Pn "\e]0;terminal\a"
}
