# Based on Luke Smith's Zsh Config 
#----------------------------------------------

# ---------------- Basic Settings ---------------
autoload -U colors && colors	# Enable colors and change prompt

setopt autocd		# Automatically cd into typed directory.

stty stop undef		# Disable ctrl-s to freeze terminal.

setopt PROMPT_SUBST     # turns on command substitution in prompt

# ---------------PROMPT -----------------------
autoload -Uz vcs_info
precmd() { vcs_info }

zstyle ':vcs_info:git:*' formats '%b'

#eval "$(starship init zsh)"      # starship prompt

# ----- THEMES FOR PROMPTS -----

#castelobruxo >_ master (with git support)
PS1='%B%{$fg[magenta]%}%(?.%1~.%{$fg[blue]%}%?) %{$fg[green]%}>_ %{$fg[yellow]%}${vcs_info_msg_0_}% %{$reset_color%} '

#castelobruxo >_
#PS1="%B%{$fg[magenta]%}%(?.%1~.%{$fg[blue]%}%?) %{$fg[green]%}>_ %{$reset_color%}"

#√ castelobruxo %
#PS1='%(?.%F{green}√.%F{red}?%?)%f %B%F{240}%1~%f%b %# '

# hogwarts >_
#PS1="%B%{$fg[yellow]%}%1~ %{$fg[red]%}>_ %{$reset_color%}"

# 5:33AM >_ studies
#PS1="%B%{$fg[red]%}%@ %{$fg[yellow]%}>_ %1~ %{$reset_color%}"

# >_ studies
#PS1="%B%{$fg[yellow]%}%(?.%1~.%?) >_ "

# [me@rubius ~t/hogwarts/studies]$
#PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

#(user@host  ) master ~ (with git status support)
#PROMPT='%B%{$fg[red]%}(%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[magenta]%}%M%{$fg[white]%}  %{$fg[red]%})%{$fg[white]%} ${vcs_info_msg_0_} ~% '

#----------------- Set History -----------------------
# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history

#----------------- Source Aliases and Shortcuts------------------

# Load aliases and shortcuts if existent.
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shortcutrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shortcutrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/aliasrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/zshnameddirrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/zshnameddirrc"

# ------------- Basic auto/tab complete: --------------
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# ---------------- vi mode -----------------
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}

# ---------------------------------

zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp" >/dev/null
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}

# -------------- Shortcuts keys -----------------

bindkey -s '^o' 'cd "$(dirname "$(fzf)")"\n'
bindkey -s '^a' 'bc -l\n'
bindkey -s '^f' 'fuzzyfm\n'

bindkey '^[[P' delete-char

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# ----------- Load Plugins -------------

# Load syntax highlighting; should be last.
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null

# Load ZSH Autosuggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null

# Load Broot if installed
#source /home/me/.config/broot/launcher/bash/br

# zsh-emacs plugin magick
source /usr/share/zsh/plugins/zsh-emacs/emacs-plugin.zsh 2>/dev/null

# zsh-vi-mode
source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.zsh 2>/dev/null

# --------------- Bash Insulter -------------------

if [ -f "/etc/bash.command-not-found" ]; then
	. /etc/bash.command-not-found
else
	print "Installing bash.command-not-found from DT's Repo"
	sudo wget -O /etc/bash.command-not-found https://gitlab.com/dwt1/bash-insulter/-/raw/master/src/bash.command-not-found
	. /etc/bash.command-not-found
	print "Done! All the best with it Now! 😉"
fi
# --------------- Welcome Art ------------------

fm600
echo -e "		\e[1;33m󰮯 \e[0m\e[1;35m 󰊠 \e[0m \e[1;34m󰊠 \e[0m \e[1;36m󰊠 \e[0m \e[1;37m󰊠 \e[0m"

#--------------------------------------------------
