#  ____  ____   ___  _____ ___ _     _____
# |  _ \|  _ \ / _ \|  ___|_ _| |   | ____|
# | |_) | |_) | | | | |_   | || |   |  _|
# |  __/|  _ <| |_| |  _|  | || |___| |___
# |_|   |_| \_\\___/|_|   |___|_____|_____|

# Adds `~/.local/bin` folders to $PATH
if [ -d ~/.local/bin ]; then
	for folder in $(find ~/.local/bin -type d); do
		export PATH="$PATH:$folder"
	done
fi

# Adds $GOPATH folder to $PATH
export PATH="$PATH:$HOME/go/bin"

# Adds cargo bin to $PATH
export PATH="$PATH:$HOME/.cargo/bin"

# Defining programs
export EDITOR="nvim"
export READER="zathura"
export VISUAL="nvim"
export BROWSER="google-chrome-stable"
export VIDEO="mpv"
export IMAGE="sxiv"
export OPENER="xdg-open"
export PAGER="less"
export WM="dwm"

# Proper VAAPI support
export LIBVA_DRIVER_NAME="i965"

# Fix java applications in dwm
export _JAVA_AWT_WM_NONREPARENTING=1

#   ____ _____ _   _ _____ ____      _    _
#  / ___| ____| \ | | ____|  _ \    / \  | |
# | |  _|  _| |  \| |  _| | |_) |  / _ \ | |
# | |_| | |___| |\  | |___|  _ <  / ___ \| |___
#  \____|_____|_| \_|_____|_| \_\/_/   \_\_____|

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Prompt Configuration
COL_B_RED='\[\e[1;31m\]'
COL_B_CYAN='\[\e[1;36m\]'
COL_RESET='\[\033[0m\]'

PS1="\$(VALU="\$?" ; if [ \$VALU == 0 ]; then printf \"$COL_B_CYAN\"; else printf \"$COL_B_RED\"; fi)"
PS1+="\w "
PS1+="\$ "
PS1+="$COL_RESET"

# Print newline AFTER executing a command
PROMPT_COMMAND="export PROMPT_COMMAND=echo"
alias clear="unset PROMPT_COMMAND; clear; PROMPT_COMMAND='export PROMPT_COMMAND=echo'"

# Disable ctrl-s and ctrl-q
stty -ixon

# Better cd with spelling awareness
shopt -s cdspell

# Infinite history
HISTSIZE= #

#     _    _     ___    _    ____  _____ ____
#    / \  | |   |_ _|  / \  / ___|| ____/ ___|
#   / _ \ | |    | |  / _ \ \___ \|  _| \___ \
#  / ___ \| |___ | | / ___ \ ___) | |___ ___) |
# /_/   \_\_____|___/_/   \_\____/|_____|____/

alias vim="nvim"

# Verbosity and settings that you pretty much just always are going to want.
alias \
	cp="cp -iv" \
	mv="mv -iv" \
	rm="rm -vI" \
	ls="ls -h --color=auto --group-directories-first"

# Colorize commands when possible.
alias \
	grep="grep --color=auto" \
	diff="diff --color=auto"

# yt-dlp
alias \
	yt="yt-dlp --add-metadata -i -S vcodec:h264" \
	yta="yt -x -f bestaudio/best"

# Useful
alias \
	o="xdg-open" \
	smic="ls config.def.h && rm -f config.h; sudo make install clean" \
	glog="git log --oneline --abbrev-commit --all --graph --decorate --color" \
	qcd="source quickcd" \
	?="google-search" \
	config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME' \
	vifm="vifmrun"
