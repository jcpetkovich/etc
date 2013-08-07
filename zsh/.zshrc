
# If we are not a login shell, then we need to source this manually
if [[ ! -o LOGIN ]]; then
    source ~/.zpath 
fi 

# Path to your oh-my-zsh configuration.
ZSH=$HOME/etc/zsh/oh-my-zsh

# Path to custom or patched plugins
ZSH_CUSTOM=$HOME/etc/zsh/custom_plugins

ZSH_THEME="gentoo"

# No auto updates please, I have my own fork
DISABLE_AUTO_UPDATE="true"

plugins=(git gitfast git-extras vi-mode extract autojump gem perl python node tmuxifier)

source $ZSH/oh-my-zsh.sh

# fix "gentoo" prompt

if [[ $ZSH_THEME == "gentoo" ]] ; then
    PROMPT[76]='c'
fi

# Variables and Exports ===============================================================

# Cleanup PATH
typeset -U PATH

# Vars
export VISUAL="`which e`"
export EDITOR=$VISUAL
export SUDO_EDITOR=$VISUAL
export LANG=en_US.UTF-8         # bugs out some stuff but fixes more
export RSENSE_HOME=$HOME/jc-public/site-lisp/rsense-0.3
export TMUXIFIER_LAYOUT_PATH=~/etc/tmux/layouts

# eval `dircolors`
export LS_COLORS='rs=0:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.pdf=00;32:*.ps=00;32:*.txt=00;32:*.patch=00;32:*.diff=00;32:*.log=00;32:*.tex=00;32:*.doc=00;32:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:'

export GROFF_NO_SGR=no

# Less Colors for Man Pages
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

# Aliases
alias ls='ls --color=auto'
alias clr='clear'
alias grep='grep --colour=auto'
alias mocp='mocp -T transparent-background'
# alias mscreen='screen -x -R -S main'
alias mscreen='echo "Try mmux instead"'
alias mmux='tmuxifier s main'
alias slrn="slrn -n"
alias man='LC_ALL=C LANG=C man'
alias f=finger
alias ll='ls -al'
alias ls='ls --color=auto '
alias zsnes='aoss32 zsnes'
alias E='sudo -e'
alias m='tmuxifier'
alias ssh='TERM=xterm ssh'      # TERM=xterm since most things misinterpret st

# Functions ===============================================================

# Global aliases
alias -g SEL='| xsel -i'

# Functions

# Ack the text of a pdf
ackp () {
	pdftotext $1 - | ack $argv[2,-1]
}

# Stream and cache a dvd using mplayer
streamdvd () {
	mplayer -cache 100000 -dvd-device $@ dvd://1
}

# Ultra simple countdown timer functionality
countdown () {
	utimer -c $@ && aplay /usr/share/sounds/purple/alert.wav
}

GIT_REPOSITORIES=(~/jc-public/ ~/jc-personal/ ~/etc/ ~/.emacs.d/ ~/mobileorg/)

within-directories () {
    eval "directories=($1)"
    for directory in $directories; do
        pushd $directory > /dev/null 
        eval $2
        echo "--------------------------------"
        popd > /dev/null
    done
}

gpull-repos () {
    within-directories "$GIT_REPOSITORIES" 'echo "Pulling for $directory"; git pull --rebase'
}

gcommit-repos () {
    emacs --batch \
          -l ~/.emacs.d/configs/setup-org-mode.el \
          -f org-mobile-push
    within-directories "$GIT_REPOSITORIES" 'echo "Committing for $directory"; git commit -a'
}

gpush-repos () {
    within-directories "$GIT_REPOSITORIES" 'echo "Pushing for $directory"; git push'
}


# Completion Options ===============================================================

# Options
setopt extendedglob
autoload -Uz predict-on
zle -N predict-on
zle -N predict-off
bindkey '^X^Z' predict-on
bindkey '^Z' predict-off

# Distro Specific Hacks ===============================================================

# Dirty hack to fix python sillyness for when I have to use archlinux
which python > /dev/null || alias python='python2'

# Same thing but for dmenu
which dmenu_path > /dev/null || alias dmenu_path='dmenu_path_c'

# EMERGE Aliases
alias emerge-sync='sudo emerge --sync && echo "----DONE EMERGE SYNC----" && sudo layman -S && echo "----DONE SYNC LAYMAN----" && eix-update && echo "----DONE SYNCING EIX CACHE----"'
alias check-update-world='emerge -puDN world'
alias update-world='sudo emerge -uDN world'

# Keybindings ===============================================================

# Bindings
bindkey "^?" backward-delete-char
bindkey "^r" history-incremental-search-backward
bindkey ' ' magic-space    # also do history expansion on space
