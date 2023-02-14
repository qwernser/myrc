# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

export PYENV_ROOT="$HOME/.local/pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

eval "$(pyenv init --path)"

#export PATH="$HOME/.local/node/bin:$PATH"
export PATH="$HOME/.local/go/bin:$PATH"

export EDITOR=nvim

#if [ -n "$PYTHONPATH" ]; then
#    export PYTHONPATH='/home/rh/.local/share/pdm/venv/lib/python3.10/site-packages/pdm/pep582':$PYTHONPATH
#else
#    export PYTHONPATH='/home/rh/.local/share/pdm/venv/lib/python3.10/site-packages/pdm/pep582'
#fi

export PATH="$HOME/go/bin:$PATH"

#if [ ! -z "${DISPLAY+aaa}" ] ; then xkbcomp $HOME/.config/output.xkb $DISPLAY 2> /dev/null ; fi

if [ -f ~/.local/secrets.sh ]; then
    . ~/.local/secrets.sh
fi

export PATH="$HOME/.local/nodejs/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

