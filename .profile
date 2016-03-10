# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

export ANDROID_HOME="/home/rgarcia/Android/Sdk/"
export GR_HOME=${HOME}/GR
export GR_USERNAME=richard.garcia

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

for file in $(\ls -1 ${GR_HOME}/engineering/bash/*.sh); do
  source $file;
done

if [ -f ${HOME}/.bash/ ]; then
  for file in $(\ls -1 ${HOME}/.bash/*.sh); do
    source $file;
  done
fi
export PATH=${GR_HOME}/engineering/bin:${PATH}

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
# export TERM=screen-256color-bce

mkdir -p "${HOME}/.history/$(date -u +%Y/%m/)"
HOSTNAME_SHORT=`hostname -s`
export PROMPT_COMMAND='history -a'
HISTFILE="${HOME}/.history/$(date -u +%Y/%m/%d.%H.%M.%S)_${HOSTNAME_SHORT}_$$"
HISTFILESIZE=10000000

histgrep () {
    grep -r "$@" ~/.history
    history | grep "$@"
}
