# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=/Users/leo/.oh-my-zsh

# JAVA_HOME stuff
export JAVA_HOME=$(/usr/libexec/java_home)

# Go Path
export GOPATH=/Users/leo/go

# Enable zmv for fancy ZSH mv action
autoload -Uz zmv

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

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
plugins=(git zsh-dircolors-solarized)

source $ZSH/oh-my-zsh.sh

# User configuration

# Set key repeat speeds
defaults write -g InitialKeyRepeat -int 12 # Normal minimum in the GUI is 15 (225 ms)
defaults write -g KeyRepeat -int 3 # Normal minimum in the GUI is 2 (30 ms)

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias ll='ls -la'
alias dc='docker-compose'
alias cat='bat'

# Kubernetes aliases
alias kdump='kubectl get all --all-namespaces'


# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"


# Add /usr/local/sbin/ to PATH since some stuff from Brew gets installed there
export PATH="$PATH:/usr/local/sbin"

# Add /Users/leo/go/bin to path for Golang binaries
export PATH="$PATH:/Users/leo/go/bin"

# Add fancy Kubectl PS1 for prompt
# https://github.com/leosunmo/kube-prompt.zsh
source /Users/leo/.oh-my-zsh/custom/plugins/kube-prompt.zsh/kube-ps1.zsh
PROMPT='${ret_status} %{$fg[cyan]%}%c%{$reset_color%} $(_kube_ps1) $(git_prompt_info)'

# added by travis gem
[ -f /Users/leo/.travis/travis.sh ] && source /Users/leo/.travis/travis.sh
export PATH="/usr/local/opt/maven@3.3/bin:$PATH"
export PATH="/usr/local/opt/maven@3.2/bin:$PATH"
export PATH="/usr/local/opt/node@8/bin:$PATH"
export PATH="/usr/local/opt/ncurses/bin:$PATH"

# aws-vault function
function av() {
if [[ $1 == "-h" ]];then
	echo -e "Usage: $0 [role-to-assume] command"
	echo -e ""
	echo -e "If a role is not provided, it will exit as the default behaviour is to drop you in a subshell."
	echo -e "To add another role, edit the av() function in your ~/.zshrc or ~/.bashrc."
	echo -e "Make sure to configure the role in your ~/.aws/config file as well."
	return 0
fi
	if [[ $# -ge 2 ]]; then
		case $1 in
			privileged|priv)
				aws-vault exec --session-ttl=4h privileged-admin -- ${@:2}
			;;
			daily)
				aws-vault exec --session-ttl=4h daily-admin -- ${@:2}
			;;
			break-glass)
				aws-vault exec --session-ttl=1h break-glass-admin -- ${@:2}
			;;
			read-only)
				aws-vault exec --session-ttl=8h read-only -- ${@:2}
			;;
			*)
				echo "Unknown profile $1. Exiting."
			;;
		esac
	else
		echo "No command detected. Exiting."
	fi
}

# Add colour to manpages
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

# Krew kubectl plugin manager
PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
