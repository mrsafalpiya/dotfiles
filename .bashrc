#  ____  ____   ___  _____ ___ _     _____
# |  _ \|  _ \ / _ \|  ___|_ _| |   | ____|
# | |_) | |_) | | | | |_   | || |   |  _|
# |  __/|  _ <| |_| |  _|  | || |___| |___
# |_|   |_| \_\\___/|_|   |___|_____|_____|

# Adds `~/.local/bin` folders to $PATH
for folder in $(find ~/.local/bin -type d); do 
	export PATH="$PATH:$folder"
done

# Adds $GOPATH folder to $PATH
export PATH="$PATH:$HOME/go/bin"

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

#   ____ _____ _   _ _____ ____      _    _
#  / ___| ____| \ | | ____|  _ \    / \  | |
# | |  _|  _| |  \| |  _| | |_) |  / _ \ | |
# | |_| | |___| |\  | |___|  _ <  / ___ \| |___
#  \____|_____|_| \_|_____|_| \_\/_/   \_\_____|

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# PS1 Configuration
PS1="\[\033[38;5;10m\]\W\[$(tput sgr0)\] \\$ \[$(tput sgr0)\]\[\e]2;\w\a\]"

# Disable ctrl-s and ctrl-q
stty -ixon

# Better cd with spelling awareness
shopt -s cdspell

# Enable vi-mode
set -o vi

# Infinite history
HISTSIZE= #

#     _    _     ___    _    ____  _____ ____
#    / \  | |   |_ _|  / \  / ___|| ____/ ___|
#   / _ \ | |    | |  / _ \ \___ \|  _| \___ \
#  / ___ \| |___ | | / ___ \ ___) | |___ ___) |
# /_/   \_\_____|___/_/   \_\____/|_____|____/

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

# youtube-dl
alias \
	yt="youtube-dl --add-metadata -i" \
	yta="yt -x -f bestaudio/best"

# Useful
alias \
	webcam="mpv av://v4l2:$1 --profile=low-latency --untimed" \
	smci="ls config.def.h && rm -f config.h; sudo make clean install" \
	glog="git log --oneline --abbrev-commit --all --graph --decorate --color" \
	conf="cat <(fd -H --max-depth 1 . $HOME) <(fd --max-depth 3 . $HOME/.config $HOME/.local/bin) | awk '{print $2}' | fzf | xargs -r $EDITOR"

#  _____ __________
# |  ___|__  /  ___|
# | |_    / /| |_
# |  _|  / /_|  _|
# |_|   /____|_|

__fzfcmd() {
	[ -n "$TMUX_PANE" ] && { [ "${FZF_TMUX:-0}" != 0 ] || [ -n "$FZF_TMUX_OPTS" ]; } &&
		echo "fzf-tmux ${FZF_TMUX_OPTS:--d${FZF_TMUX_HEIGHT:-40%}} -- " || echo "fzf"
	}

__fzf_history__() {
	local output
	output=$(
	builtin fc -lnr -2147483648 |
		last_hist=$(HISTTIMEFORMAT='' builtin history 1) perl -n -l0 -e 'BEGIN { getc; $/ = "\n\t"; $HISTCMD = $ENV{last_hist} + 1 } s/^[ *]//; print $HISTCMD - $. . "\t$_" if !$seen{$_}++' |
		FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS +m --read0" $(__fzfcmd) --query "$READLINE_LINE"
			) || return
			READLINE_LINE=${output#*$'\t'}
			if [ -z "$READLINE_POINT" ]; then
				echo "$READLINE_LINE"
			else
				READLINE_POINT=0x7fffffff
			fi
		}

__fzf_files__() {
	ls -1a | fzf -m --height 40% | tr '\r\n' ' ' | xclip -selection clipboard
}
__cd_with_fzf__() {
	cd "$(fd -E go/ -E newwin32 -t d | fzf --preview="tree -L 1 {}" --preview-window=:hidden)" && echo "$PWD"
}

# CTRL+R - Paste the selected command from history into the command line
bind -m vi-command -x '"\C-p": __fzf_history__'
bind -m vi-insert -x '"\C-p": __fzf_history__'

# CTRL+F - Paste the file/folder name from current directory
bind -m vi-command -x '"\C-f": __fzf_files__'
bind -m vi-insert -x '"\C-f": __fzf_files__'

# CTRL+Q - cd with fzf
bind -m vi-command -x '"\C-q": __cd_with_fzf__'
bind -m vi-insert -x '"\C-q": __cd_with_fzf__'
