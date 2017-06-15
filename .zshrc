# Path to your oh-my-zsh installation.
  export ZSH=/home/leop/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="agnoster"

# Setting Default user to hide it in the terminal when logged in as me on localhost

export DEFAULT_USER=leop

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
# DISABLE_AUTO_TITLE="true"

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
plugins=(git zsh-autosuggestions zsh-256color solarized-man zsh-syntax-highlighting zsh-completions sublime)

# User configuration

# export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# Dynamically add Kubectl completion
source <(kubectl completion zsh)

# You may need to manually set your language environment
export LANG=en_GB.UTF-8
export LC_CTYPE=en_GB.UTF-8
export LC_ALL=en_GB.UTF-8


# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Custom 

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

function ds() {
sudo docker stats $(sudo docker ps|grep -v "NAMES"|awk '{ print $NF }'|tr "\n" " ")
}

function di() {
    sudo docker inspect --format '{{.Name}} - {{.NetworkSettings.IPAddress}} - {{.Config.Image}}' `sudo docker ps -q`
}

export GOPATH=$HOME/go

function kus() {
case $1 in
  blue)
    kubectl --context=prod-us --namespace=blue ${@:2}
    ;;
  red)
    kubectl --context=prod-us --namespace=red ${@:2}
  ;;
  green)
    kubectl --context=prod-us --namespace=green ${@:2}
  *)
    kubectl --context=prod-us $@
esac
}

function keu() {
case $1 in
  blue)
    kubectl --context=prod-eu --namespace=blue ${@:2}
    ;;
  red)
    kubectl --context=prod-eu --namespace=red ${@:2}
    ;;
  *)
    kubectl --context=prod-eu $@
esac
}


man() {
	env \
		LESS_TERMCAP_md=$'\e[1;36m' \
		LESS_TERMCAP_me=$'\e[0m' \
		LESS_TERMCAP_se=$'\e[0m' \
		LESS_TERMCAP_so=$'\e[1;40;92m' \
		LESS_TERMCAP_ue=$'\e[0m' \
		LESS_TERMCAP_us=$'\e[1;32m' \
			man "$@"
}


export PATH=$PATH:/home/leop/go/bin/:/usr/local/go/bin

