# Path to your oh-my-zsh configuration.
ZSH=$HOME/jc-personal/etc/zsh/oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="gentoo"


# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want disable red dots displayed while waiting for completion
# DISABLE_COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse) 
plugins=(git vi-mode extract)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

# Paths

# Classpath stuff
# CLJ_DIR=$HOME/.m2/repository
# CLOJURE=$CLJ_DIR/org/clojure/clojure/1.2.0/clojure-1.2.0.jar
# CONTRIB=$CLJ_DIR/org/clojure/clojure-contrib/1.2.0/clojure-contrib-1.2.0.jar
# SWANK=$CLJ_DIR/swank-clojure/swank-clojure/1.2.1/swank-clojure-1.2.1.jar
# MYCLOJURE=$HOME/src/clojure
# MYCLASSES=$HOME/src/clojure/classes
# MYSRC=$HOME/src/clojure/src
# INCANTER=$HOME/src/clojure/src/incanter/modules/incanter-app/target/incanter-app-1.0.0.jar

# export CLASSPATH=$PWD:$CLOJURE:$CONTRIB:$MYCLASSES:$MYSRC:$MYCLOJURE:$SWANK:$INCANTER:.

# fix "gentoo" prompt

if [[ $ZSH_THEME == "gentoo" ]] ; then
    PROMPT[76]='c'
fi

# Language exports ===============================================================

# Python exports
export PYTHONPATH=/home/jcp/src/thesis/src:~/src/python

# Perl exports
if [ -d ~/perl5/lib/perl5/i686-linux-thread-multi ] ; then
    export PERL_LOCAL_LIB_ROOT="$HOME/perl5";
    export PERL5LIB="$HOME/perl5/lib/perl5/i686-linux-thread-multi:$HOME/perl5/lib/perl5";
else
    export PERL5LIB="$HOME/perl5/lib/perl5/x86_64-linux:$HOME/perl5/lib/perl5";
fi

if [ -d ~/src/perl ] ; then
    export PERL5LIB="$PERL5LIB:$HOME/src/perl";
fi
export PERL_MB_OPT="--install_base $HOME/perl5";
export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5";
export PATH="$HOME/perl5/bin:$PATH"

if [ -d ~/perl5 ] ; then
    export MANPATH=~/perl5/man:"$MANPATH"
fi

if [ -d ~/jc-public/projects/eval-lab/install ] ; then
    export PERL5LIB="$PERL5LIB:$HOME/jc-public/projects/eval-lab/install"
fi

if [ -d ~/bin ] ; then
    PATH=~/bin:"${PATH}"
fi

# NIST software?
if [ -d ~/src/thesis/nist ] ; then
    PATH=~/src/thesis/nist/bin:"${PATH}"
    MANPATH=~/src/thesis/nist/man:"${MANPATH}"
fi

# Thesis project?
if [ -d ~/src/thesis/bin ] ; then
    PATH=~/src/thesis/bin:"${PATH}"
fi

# Cleanup PATH
typeset -U PATH

# Vars
export VISUAL="`which e`"
export EDITOR=$VISUAL
export SUDO_EDITOR=$VISUAL
export LANG=en_US.UTF-8         # buggs out some stuff but fixes more
export RSENSE_HOME=$HOME/jc-public/site-lisp/rsense-0.3

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
alias mscreen='screen -x -R -S main'
alias slrn="slrn -n"
alias man='LC_ALL=C LANG=C man'
alias f=finger
alias ll='ls -al'
alias ls='ls --color=auto '
alias zsnes='aoss32 zsnes'
alias E='sudo -e'

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
    within-directories "$GIT_REPOSITORIES" 'echo "Pulling for $directory"; git pull'
}

gcommit-repos () {
    within-directories "$GIT_REPOSITORIES" 'echo "Committing for $directory"; git commit -a'
}

gpush-repos () {
    within-directories "$GIT_REPOSITORIES" 'echo "Pushing for $directory"; git push'
}

# Dirty hack to fix python sillyness for when I have to use archlinux
which python > /dev/null || alias python='python2'

# Same thing but for dmenu
which dmenu_path > /dev/null || alias dmenu_path='dmenu_path_c'

# EMERGE Aliases
alias emerge-sync='sudo emerge --sync && echo "----DONE EMERGE SYNC----" && sudo layman -S && echo "----DONE SYNC LAYMAN----" && eix-update && echo "----DONE SYNCING EIX CACHE----"'
alias check-update-world='emerge -puDN world'
alias update-world='sudo emerge -uDN world'

# Bindings
bindkey "^?" backward-delete-char
bindkey "^r" history-incremental-search-backward
bindkey ' ' magic-space    # also do history expansion on space
