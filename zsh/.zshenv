
# Only load path if we are the first shell and not a login shell

if [[ $SHLVL == 1 && ! -o LOGIN ]]; then
    source ~/.zpath
fi
