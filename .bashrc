export PATH=/usr/local/bin:/usr/local/sbin:$PATH # use homebrew's coreutils

# g shell setup
if [ -f "${HOME}/.g/env" ]; then
    . "${HOME}/.g/env"
fi
unalias g