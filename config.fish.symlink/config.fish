# config.fish - configure fish

function fish_env_update
				egrep "^export" /etc/profile.env | \
				while read e
								set var (echo $e | sed -E "s/^export ([A-Z_]+)=(.*)\$/\1/")
								set value (echo $e | sed -E "s/^export ([A-Z_]+)=(.*)\$/\2/")
								# remove surrounding quotes if existing
								set value (echo $value | sed -E "s/^\"(.*)\"\$/\1/")
								if test $var = "PATH"
												set value (echo $value | sed -E "s/^'(.*)'\$/\1/")
												set value (echo $value | sed -E "s/:/ /g")
												# use eval because we need to expand the value
												eval "set value $value"
												# echo "Count of value: "(count $value)
												for val in $value
																# echo "set -xg fish_user_paths $val"
																set -xg fish_user_paths $val $fish_user_paths
																# echo "$PATH"
												end
												continue
								else if test $var = "MANPATH"
												# echo "set -xg MANPATH $value"
												eval "set -xg MANPATH $value"
												continue
								end
								# evaluate variables. we can use eval because we most likely just used "$var"
								set value (eval echo $value)
								# echo "set -xg '$var' '$value' (via '$e')"
								set -xg $var $value
				end
end

function varclear -d 'Remove duplicates from an environment variable'
	if test (count $argv) = 1
		set -l newvar
		set -l dupcount 0

		for v in $$argv
			if contains -- $v $newvar
				set dupcount (math $dupcount + 1)
			else
				set newvar $newvar $v
			end
		end
		set $argv $newvar
		test $dupcount -gt 0
		and echo Removed $dupcount duplicates from $argv
	else
		for a in $argv
			varclear $a
		end
	end
end

# Load Gentoo environment variables when we are a login shell
if begin; status -l; and test $SHLVL -eq 1; end
fish_env_update
varclear fish_user_paths
end

# Language exports ===============================================================

# Python exports
set -xg PYTHONPATH ~/src/thesis/src ~/src/python

# Perl exports
if test -d ~/perl5/lib/perl5/i686-linux-thread-multi
				set -xg PERL_LOCAL_LIB_ROOT "$HOME/perl5"
				set -xg PERL5LIB "$HOME/perl5/lib/perl5/i686-linux-thread-multi:$HOME/perl5/lib/perl5"
else
				set -xg PERL5LIB "$HOME/perl5/lib/perl5/x86_64-linux:$HOME/perl5/lib/perl5"
end

if test -d ~/src/perl
				set -xg PERL5LIB="$PERL5LIB:$HOME/src/perl"
end

if test -d ~/perl5
				set -xg MANPATH ~/perl5/man:"$MANPATH"
end

if test -d ~/jc-public/projects/eval-lab/install
				set -xg PERL5LIB "$PERL5LIB:$HOME/jc-public/projects/eval-lab/install"
end

if test -d ~/.plenv/bin
				set -xg fish_user_paths ~/.plenv/bin $fish_user_paths
end

if test -d ~/.plenv/shims
				set -xg fish_user_paths ~/.plenv/shims $fish_user_paths
end

# Path Exports

if test -d ~/bin
	pushd ~/bin > /dev/null
	for d in (find . -type d | grep -vE '^\.$' | sed 's/^.//' | sort -r)
		set -xg fish_user_paths ~/bin"$d" $fish_user_paths
	end
	popd > /dev/null
	set -xg fish_user_paths ~/bin $fish_user_paths
end

if test -d ~/perl5/bin
				set -xg fish_user_paths ~/perl5/bin $fish_user_paths
end

# Cabal Exports
if test -d ~/.cabal/bin
				set -xg fish_user_paths ~/.cabal/bin $fish_user_paths
				set -xg MANPATH ~/.cabal/share/man:"$MANPATH"
end

# local software exports
if test -d ~/.local/bin
				set -xg fish_user_paths ~/.local/bin $fish_user_paths
				set -xg MANPATH ~/.local/share/man:"$MANPATH"
end

# NIST software?
if test -d ~/src/thesis/nist
				set -xg fish_user_paths ~/src/thesis/nist/bin $fish_user_paths
				set -xg MANPATH ~/src/thesis/nist/man:"$MANPATH"
end

# Thesis project?
if test -d ~/src/thesis/bin
				set -xg fish_user_paths ~/src/thesis/bin $fish_user_paths
end

# Ruby path
if test -d ~/.gem/ruby
				for d in (ls -d ~/.gem/ruby/*/)
								set -xg fish_user_paths {$d}bin $fish_user_paths
				end
end

# Rbenv
if test -d ~/.rbenv/bin
				set -xg fish_user_paths ~/.rbenv/bin $fish_user_paths
				if which rbenv >/dev/null
								status --is-interactive; and . (rbenv init -|psub)
				end
end

# tmuxifier
if test -d ~/etc/tmux/tmuxifier/bin
				set -xg fish_user_paths ~/etc/tmux/tmuxifier/bin $fish_user_paths
end

# req
if test -d ~/etc/plumbing/req/bin
				set -xg fish_user_paths ~/etc/plumbing/req $fish_user_paths
end

# req
if test -d ~/.cask/bin
				set -xg fish_user_paths ~/.cask/bin $fish_user_paths
end

# Go
if test -d ~/labs/go
	if which go 2>&1 > /dev/null
				set -xg GOPATH ~/labs/go
				set -xg GOBIN $GOPATH/bin
				set -xg GOROOT (go env GOROOT)
				set -xg GOMAXPROCS (cat /proc/cpuinfo | grep processor | wc -l)
				set -xg fish_user_paths (go env GOROOT)/bin $fish_user_paths
				set -xg fish_user_paths (go env GOBIN) $fish_user_paths
	end
end

# Rust
if test -d ~/labs/rust
	set -xg RUST_SRC_PATH ~/labs/rust/src
end
if test -d ~/.cargo/bin
	set -xg fish_user_paths ~/.cargo/bin $fish_user_paths
end

# Gentoo
if test -d ~/prj/overlay-petkovich
	set -xg PERSONAL_OVERLAY ~/prj/overlay-petkovich
end

if test -d ~/mail
	set -xg MAILDIR ~/mail
end

# Finish setting up MANPATH

set -xg MANPATH ":"$MANPATH

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
set -xg PERL_MB_OPT "--install_base $HOME/perl5";
set -xg PERL_MM_OPT "INSTALL_BASE=$HOME/perl5";

# Ruby
set -xg RUBYOPT

# Vars
set -xg VISUAL (which e)
set -xg EDITOR $VISUAL
set -xg SUDO_EDITOR "emacsclient -c"

if test (hostname) = "tricorder"
	# resource constrained
	set -xg BROWSER "qutebrowser"
else
	set -xg BROWSER "firefox"
end
set -xg LANG en_US.UTF-8         # bugs out some stuff but fixes more
set -xg RSENSE_HOME $HOME/jc-public/site-lisp/rsense-0.3
set -xg TMUXIFIER_LAYOUT_PATH ~/etc/tmux/layouts
set -xg REQ_DIR ~/etc/plumbing/req
set -xg USER_PATHS "$HOME/etc $HOME/labs $HOME/prj $HOME/.spacemacs.d $HOME/journal"
set -xg HOME_SERVER 192.168.2.15
set -xg SUDO_ASKPASS "$HOME/bin/askpass"

set -xg XDG_DESKTOP_DIR $HOME
set -xg XDG_DOWNLOAD_DIR $HOME"/dwn"
set -xg XDG_TEMPLATES_DIR $HOME
set -xg XDG_PUBLICSHARE_DIR $HOME
set -xg XDG_DOCUMENTS_DIR $HOME"/dcs"
set -xg XDG_MUSIC_DIR $HOME"/media/music"
set -xg XDG_PICTURES_DIR $HOME"/media/Photos"
set -xg XDG_VIDEOS_DIR $HOME"/media/Movies"

# Gnu Global
set -xg GTAGSLABEL ctags

set -xg GROFF_NO_SGR no

# Less Colors for Man Pages
set -xg LESS_TERMCAP_mb \e\[01\x3B31m       # begin blinking
set -xg LESS_TERMCAP_md \e\[01\x3B38\x3B5\x3B74m  # begin bold
set -xg LESS_TERMCAP_me \e\[0m           # end mode
set -xg LESS_TERMCAP_se \e\[0m           # end standout-mode
set -xg LESS_TERMCAP_so \e\[38\x3B5\x3B246m    # begin standout-mode - info box
set -xg LESS_TERMCAP_ue \e\[0m           # end underline
set -xg LESS_TERMCAP_us \e\[04\x3B38\x3B5\x3B146m # begin underline

# LS_COLORS
eval (dircolors -c)
set -xg LS_COLORS $LS_COLORS

# Aliases
alias ls='ls --color=auto'
alias sl='ls'
alias clr='clear'
alias grep='grep --colour=auto'
alias mocp='mocp -T transparent-background'
alias mscreen='echo "Try mmux instead"'
alias mmux='tmuxifier s main'
alias zsnes='aoss32 zsnes'
alias E='sudo -e'
alias m='tmuxifier'
alias ssh='env TERM=xterm-256color ssh'      # TERM=xterm since most things misinterpret st
alias x='extract'
alias r='R'
alias py='jupyter console'
if which netcat > /dev/null 2>&1
	alias nc='netcat'
end

# Additional git aliases
alias grp='git rev-parse --short HEAD'
alias glp='git log --graph --decorate --all'
alias gst='git status'

function fish_greeting
end

function fish_mode_prompt
end

function fish_user_key_bindings
				fish_vi_key_bindings

				# Sane behaviour of C-c
				bind -m insert \cc 'commandline ""'
				bind -M insert \cc 'commandline ""'
				bind -M visual -m insert \cc 'commandline ""'

				# Paste behaviour is wrong
				bind p forward-char yank
				bind P yank

				# M-p and M-n for history search (like emacs commit mode)
				bind -m insert \ep history-search-backward
				bind -M insert \ep history-search-backward
				bind -M visual -m insert \ep history-search-backward
				bind -m insert \en history-search-forward
				bind -M insert \en history-search-forward
				bind -M visual -m insert \en history-search-forward

				# C-p and C-n for history token search
				bind -m insert \cp history-token-search-backward
				bind -M insert \cp history-token-search-backward
				bind -M visual -m insert \cp history-token-search-backward
				bind -m insert \cn history-token-search-forward
				bind -M insert \cn history-token-search-forward
				bind -M visual -m insert \cn history-token-search-forward

				# C-f and C-b forward and back char
				bind -m insert \cf forward-char
				bind -M insert \cf forward-char
				bind -M visual -m insert \cf forward-char
				bind -m insert \cb backward-char
				bind -M insert \cb backward-char
				bind -M visual -m insert \cb backward-char

				# Manpages
				bind $argv -m insert \eh __fish_man_page
				bind $argv -M insert \eh __fish_man_page
				bind $argv -M visual -m insert \eh __fish_man_page

				# List current token
	bind $argv -m insert \el __fish_list_current_token
	bind $argv -M insert \el __fish_list_current_token
	bind $argv -M visual -m insert \el __fish_list_current_token

				# Show current command
				alias __show_command='set tok (commandline -pt); if test $tok[1]; echo; whatis $tok[1]; commandline -f repaint; end'
	bind $argv -m insert \ew __show_command
	bind $argv -M insert \ew __show_command
	bind $argv -M visual -m insert \ew __show_command


end

powerline-setup
if not pgrep -f powerline-daemon > /dev/null
				powerline-daemon
end
