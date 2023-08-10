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
export GOPATH=$HOME/go
export PATH="$PATH:$GOPATH/bin"

# Adds cargo bin to $PATH
export PATH="$PATH:$HOME/.cargo/bin"

# Adds composer bin to $PATH
export PATH="$PATH:$HOME/.config/composer/vendor/bin"

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
export LIBVA_DRIVER_NAME="iHD"

# Fix java applications in dwm
export _JAVA_AWT_WM_NONREPARENTING=1

# Better font in java applications
export JDK_JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true"

# Dark theme
export GTK_THEME=Adwaita:dark
export GTK2_RC_FILES=/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc
export QT_STYLE_OVERRIDE=adwaita-dark

#   ____ _____ _   _ _____ ____      _    _
#  / ___| ____| \ | | ____|  _ \    / \  | |
# | |  _|  _| |  \| |  _| | |_) |  / _ \ | |
# | |_| | |___| |\  | |___|  _ <  / ___ \| |___
#  \____|_____|_| \_|_____|_| \_\/_/   \_\_____|

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Prompt Configuration
source ~/.git-prompt.sh  # curl -o ~/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE="true"
export GIT_PS1_SHOWSTASHSTATE="true"
export GIT_PS1_SHOWUNTRACKEDFILES="true"
export GIT_PS1_SHOWUPSTREAM="auto"

function timer_now {
    date +%s%N
}

function timer_start_func {
    local old_=$1
    timer_start=${timer_start:-$(timer_now)}
    : "$old_"
}

function timer_stop {
    local delta_us=$((($(timer_now) - $timer_start) / 1000))
    local us=$((delta_us % 1000))
    local ms=$(((delta_us / 1000) % 1000))
    local s=$(((delta_us / 1000000) % 60))
    local m=$(((delta_us / 60000000) % 60))
    local h=$((delta_us / 3600000000))
    # Goal: always show around 3 digits of accuracy
    if ((h > 0)); then timer_show=${h}h${m}m
    elif ((m > 0)); then timer_show=${m}m${s}s
    elif ((s >= 10)); then timer_show=${s}.$((ms / 100))s
    elif ((s > 0)); then timer_show=${s}.$(printf %03d $ms)s
    elif ((ms >= 100)); then timer_show=${ms}ms
    elif ((ms > 0)); then timer_show=${ms}.$((us / 100))ms
    else timer_show=${us}us
    fi
    unset timer_start
}


set_prompt () {
	LAST_STATUS=$?

	COL_RED='\[\e[0;31m\]'
	COL_B_RED='\[\e[1;31m\]'
	COL_CYAN='\[\e[0;36m\]'
	COL_B_CYAN='\[\e[1;36m\]'
	COL_RED='\[\e[0;31m\]'
	COL_RED_BG='\[\e[1;41m\]'
	COL_GREEN='\[\e[0;32m\]'
	COL_GREEN_BG='\[\e[1;43m\]'
	COL_WHITE='\[\e[1;37m\]'
	COL_BLACK='\[\e[1;30m\]'
	COL_RESET='\[\033[0m\]'

	timer_stop

	PS1="\$(if [ \${PIPESTATUS[-1]} == 0 ]; then printf \"$COL_B_CYAN\"; else printf \"$COL_B_RED\"; fi)"
	PS1+="\w "

	if [ -n "$(jobs -p)" ]; then
		PS1+="$COL_BLACK$COL_GREEN_BG \j $COL_RESET "
		PS1+="\$(if [ \${PIPESTATUS[-1]} == 0 ]; then printf \"$COL_B_CYAN\"; else printf \"$COL_B_RED\"; fi)"
	fi

	PS1+="\$(LAST_EXIT_CODE=\"\${PIPESTATUS[-1]}\"; if [ \$LAST_EXIT_CODE != 0 ]; then printf \"$COL_RED_BG$COL_WHITE \$LAST_EXIT_CODE $COL_RESET \"; fi)"
	PS1+="\$(if [ \${PIPESTATUS[-1]} == 0 ]; then printf \"$COL_CYAN\"; else printf \"$COL_RED\"; fi)"

	PS1+="$timer_show "

	PS1+="\$(if [ \${PIPESTATUS[-1]} == 0 ]; then printf \"$COL_CYAN\"; else printf \"$COL_RED\"; fi)"
	PS1+="$(printf $COL_GREEN)"
	PS1+='$(__git_ps1 "[%s]")'
	PS1+="\$(if [ \${PIPESTATUS[-1]} == 0 ]; then printf \"$COL_B_CYAN\"; else printf \"$COL_B_RED\"; fi)"
	PS1+="\n\$ "
	PS1+="$(printf $COL_RESET)"
}

trap 'timer_start_func "$_"' DEBUG
PROMPT_COMMAND="export PROMPT_COMMAND=\"echo; set_prompt\"; set_prompt"
alias clear="unset PROMPT_COMMAND; clear; PROMPT_COMMAND='export PROMPT_COMMAND=\"echo; set_prompt\"; set_prompt'"

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

alias vim=nvim

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
	yt="yt-dlp --add-metadata -i" \
	yta="yt -x -f bestaudio/best"

# Useful
alias \
	o="xdg-open" \
	smic="make clean && rm -f config.h && make && sudo make install" \
	glog="git log --oneline --abbrev-commit --all --graph --decorate --color" \
	qcd="source quickcd" \
	?="google-search" \
	config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME' \
	vifm="vifmrun"
