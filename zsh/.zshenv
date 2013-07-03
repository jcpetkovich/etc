# Language exports ===============================================================

# Python exports
export PYTHONPATH=~/src/thesis/src:~/src/python

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

# Cabal Exports
if [ -d ~/.cabal/bin ] ; then
    export PATH=~/.cabal/bin:"${PATH}"
fi

# Node.js exports
if [ -d ~/.local/bin ] ; then
    export PATH=~/.local/bin:"${PATH}"
    export MANPATH=~/.local/share/man:"${MANPATH}"
fi

# NIST software?
if [ -d ~/src/thesis/nist ] ; then
    export PATH=~/src/thesis/nist/bin:"${PATH}"
    export MANPATH=~/src/thesis/nist/man:"${MANPATH}"
fi

# Thesis project?
if [ -d ~/src/thesis/bin ] ; then
    export PATH=~/src/thesis/bin:"${PATH}"
fi

# Ruby path
if [ -d ~/.gem/ruby ] ; then
    for d in $(ls -d ~/.gem/ruby/*/); do
        export PATH=${d}bin:"${PATH}"
    done
fi
