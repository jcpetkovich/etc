# config.fish - configure fish

function fish_env_update
        egrep "^export" /etc/profile.env | \
        while read e
                set var (echo $e | sed -E "s/^export ([A-Z_]+)=(.*)\$/\1/")
                set value (echo $e | sed -E "s/^export ([A-Z_]+)=(.*)\$/\2/")
                # remove surrounding quotes if existing
                set value (echo $value | sed -E "s/^\"(.*)\"\$/\1/")
                if test $var = "PATH"
                        set value (echo $value | sed -E "s/:/ /g")
                        # use eval because we need to expand the value
                        echo "set -xU fish_user_paths $value"
                        eval set -xU fish_user_paths $value
                        continue
                else if test $var = "MANPATH"
                        echo "set -xU MANPATH $value"
                        eval "set -xU MANPATH $value"
                        continue
                end
                # evaluate variables. we can use eval because we most likely just used "$var"
                set value (eval echo $value)
                echo "set -xU '$var' '$value' (via '$e')"
                set -xU $var $value
        end
end

# Load Gentoo environment variables when we are a login shell
if begin; status -l; and test $SHLVL -eq 1; end
fish_env_update
end

# Language exports ===============================================================

# Python exports
set -xU PYTHONPATH ~/src/thesis/src ~/src/python

# Perl exports
if test -d ~/perl5/lib/perl5/i686-linux-thread-multi
        set -xU PERL_LOCAL_LIB_ROOT "$HOME/perl5"
        set -xU PERL5LIB "$HOME/perl5/lib/perl5/i686-linux-thread-multi" "$HOME/perl5/lib/perl5"
else
        set -xU PERL5LIB "$HOME/perl5/lib/perl5/x86_64-linux" "$HOME/perl5/lib/perl5"
end

if test -d ~/src/perl
        set -xU PERL5LIB="$PERL5LIB" "$HOME/src/perl"
end

if test -d ~/perl5
    set -xU MANPATH ~/perl5/man:"$MANPATH"
end

if test -d ~/jc-public/projects/eval-lab/install
    set -xU PERL5LIB "$PERL5LIB" "$HOME/jc-public/projects/eval-lab/install"
end


# Path Exports

if test -d ~/bin
    set -xU fish_user_paths ~/bin $fish_user_paths
end

if test -d ~/perl5/bin
    set -xU fish_user_paths ~/perl5/bin $fish_user_paths
end

# Cabal Exports
if test -d ~/.cabal/bin
    set -xU fish_user_paths ~/.cabal/bin $fish_user_paths
    set -xU MANPATH ~/.cabal/share/man:"$MANPATH"
end

# local software exports
if test -d ~/.local/bin
    set -xU fish_user_paths ~/.local/bin $fish_user_paths
    set -xU MANPATH ~/.local/share/man:"$MANPATH"
end

# NIST software?
if test -d ~/src/thesis/nist
    set -xU fish_user_paths ~/src/thesis/nist/bin $fish_user_paths
    set -xU MANPATH ~/src/thesis/nist/man:"$MANPATH"
end

# Thesis project?
if test -d ~/src/thesis/bin
    set -xU fish_user_paths ~/src/thesis/bin $fish_user_paths
end

# Ruby path
if test -d ~/.gem/ruby
    for d in (ls -d ~/.gem/ruby/*/)
        set -xU fish_user_paths {$d}bin $fish_user_paths
    end
end

# tmuxifier
if test -d ~/etc/tmux/tmuxifier/bin
    set -xU fish_user_paths ~/etc/tmux/tmuxifier/bin $fish_user_paths
end

# req
if test -d ~/etc/plumbing/req/bin
    set -xU fish_user_paths ~/etc/plumbing/req $fish_user_paths
end

# req
if test -d ~/.cask/bin
    set -xU fish_user_paths ~/.cask/bin $fish_user_paths
end

# Go
if test -d ~/.go
    set -xU GOPATH ~/.go
    set -xU GOBIN ~/.go/bin
    set -xU fish_user_paths ~/.go/bin $fish_user_paths
end

# Finish setting up MANPATH

set -xU MANPATH ":"$MANPATH

# Setup fasd
if which fasd > /dev/null 2>&1
        function -e fish_preexec _run_fasd
                fasd --proc (fasd --sanitize $argv) > "/dev/null" 2>&1
        end

        function j
                cd (fasd -e 'printf %s' "$argv")
        end
else
        echo "
You should install fasd:

    cd ~/etc/zsh/fasd
    PREFIX=~/.local make install
"
end

# Perl CPAN install locations
set -xU PERL_MB_OPT "--install_base $HOME/perl5";
set -xU PERL_MM_OPT "INSTALL_BASE=$HOME/perl5";

# Vars
set -xU VISUAL (which e)
set -xU EDITOR $VISUAL
set -xU SUDO_EDITOR $VISUAL
set -xU LANG en_US.UTF-8         # bugs out some stuff but fixes more
set -xU RSENSE_HOME $HOME/jc-public/site-lisp/rsense-0.3
set -xU TMUXIFIER_LAYOUT_PATH ~/etc/tmux/layouts
set -xU REQ_DIR ~/etc/plumbing/req


set -xU GROFF_NO_SGR no

# Less Colors for Man Pages
set -xU LESS_TERMCAP_mb \e\[01\x3B31m       # begin blinking
set -xU LESS_TERMCAP_md \e\[01\x3B38\x3B5\x3B74m  # begin bold
set -xU LESS_TERMCAP_me \e\[0m           # end mode
set -xU LESS_TERMCAP_se \e\[0m           # end standout-mode
set -xU LESS_TERMCAP_so \e\[38\x3B5\x3B246m    # begin standout-mode - info box
set -xU LESS_TERMCAP_ue \e\[0m           # end underline
set -xU LESS_TERMCAP_us \e\[04\x3B38\x3B5\x3B146m # begin underline

# Aliases
alias l='ls -al'
alias ls='ls --color=auto'
alias clr='clear'
alias grep='grep --colour=auto'
alias mocp='mocp -T transparent-background'
alias mscreen='echo "Try mmux instead"'
alias mmux='tmuxifier s main'
alias slrn="slrn -n"
alias ll='ls -al'
alias ls='ls --color=auto '
alias zsnes='aoss32 zsnes'
alias E='sudo -e'
alias m='tmuxifier'
alias ssh='TERM=xterm-256color ssh'      # TERM=xterm since most things misinterpret st

# Additional git aliases
alias grp='git rev-parse --short HEAD'
alias glp='git log --graph --decorate --all'
alias gst='git status'


function fish_user_key_bindings
        # fish_vi_key_bindings
        # bind -m insert \cc 'commandline ""'
        # bind -M insert \cc 'commandline ""'
        # bind -M visual -m insert \cc 'commandline ""'
        bind \ep history-search-backward
        bind \en history-search-backward
end