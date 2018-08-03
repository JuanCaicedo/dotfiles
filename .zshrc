# Path to your oh-my-zsh installation.
export ZSH=/Users/juan/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="juan"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  zsh-autosuggestions
  cp
  git
  nvm
  zsh-completions
  virtualenv
  virtualenvwrapper
)
# User configuration

source $ZSH/oh-my-zsh.sh

nvm_use () {
  if [ -f .nvmrc ]; then
    nvm use
  fi
}

# Git functions
branch-name () {
  git rev-parse --abbrev-ref HEAD
}

function pp {
  current=$(branch-name)
  git push -u origin $current
}

function ppno {
    current=$(branch-name)
    git push -u origin $current --no-verify
}

function commit {
    git add .
    git commit -am "$1"
}

# Notes functions

export NOTES_HOME=$HOME/code/notes/

function add-notes {
    name=${PWD##*/}
    notes_dir=$NOTES_HOME/$name
    if [ -h ./local_notes ];
    then
       return
    elif [ -d ./local_notes ];
    then
        mv ./local_notes $notes_dir;
    else
        mkdir -p $notes_dir
    fi
    ln -s $notes_dir local_notes
    touch local_notes/notes.org
}

function new-journal {
  touch $(date +'%-m-%d-%y').org
}

# Misc functions
function tabname {
  printf "\e]1;$1\a"
}

function copy-last {
    history | tail -n 1 | awk '{$1=""; print $0}' | pbcopy
}

# aliases
alias zshconfig="vim ~/.zshrc"
alias npm='nocorrect npm'
alias fab='nocorrect fab'
alias mocha='nocorrect mocha'
alias chrome='open -a "Google Chrome"'
alias killcamera='sudo killall VDCAssistant; sudo killall AppleCameraAssistant'
alias gbD='git b -D'
alias spacemacs='emacs'
alias nm="/usr/local/bin/notify-me"
alias yarn="yarn --ignore-engines"
alias git=hub
alias emacs-freeze="pkill -SIGUSR2 emacs"
alias npmls="npm ls --depth=0"
alias gits="git s"
# alias edit="emacsclient -t"
# Avoid node errors
ulimit -n 10000

nvm use stable --silent

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# export NVM_DIR="/Users/JuanCaicedo/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Virtualenvwrapper things
export WORKON_HOME=$HOME/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh

# rbenv
eval "$(rbenv init -)"
# export EDITOR="emacsclient -t"
export VISUAL="emacsclient -t"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
