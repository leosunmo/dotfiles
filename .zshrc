# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

#zmodload zsh/zprof

# Antibody setup
source <(antibody init)

# Load zsh plugins with Antibody but only if we can't use
# the pre-generated zsh_plugins.sh script
if [[ -f ~/.zsh_plugins.sh ]]; then 
	source ~/.zsh_plugins.sh
else
	antibody bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh
fi

autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done

# Make sure oh-my-zsh is happy
ZSH=$(antibody path ohmyzsh/ohmyzsh)

# Enable zmv for fancy ZSH mv action
autoload -Uz zmv

source <(kubectl completion zsh)

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


# User configuration


# JAVA_HOME stuff
if [ $(uname 2> /dev/null) != "Linux" ]; then
export JAVA_HOME=$(/usr/libexec/java_home)
fi

# Go Path
export GOPATH=~/go
export GO111MODULE=on

if [ "$(uname 2> /dev/null)" != "Linux" ]; then
	# Set key repeat speeds on mac
	defaults write -g InitialKeyRepeat -int 12 # Normal minimum in the GUI is 15 (225 ms)
	defaults write -g KeyRepeat -int 3 # Normal minimum in the GUI is 2 (30 ms)
elif hash gsettings 2>/dev/null; then 
	# Set key repeat in Gnome
	gsettings set org.gnome.desktop.peripherals.keyboard repeat true
	gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 15
	gsettings set org.gnome.desktop.peripherals.keyboard delay 200
fi

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
alias t='todo.sh'

# Kubernetes aliases
alias kdump='kubectl get all --all-namespaces'
alias k='kubectl'

# Alias xgd-open to open for convenience
alias open='xdg-open'

# Pip3 to pip
alias pip='pip3'

# Tool ENVVars
export FLUX_FORWARD_NAMESPACE=flux

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"


# Add /usr/local/sbin/ to PATH since some stuff from Brew gets installed there
export PATH="$PATH:/usr/local/sbin"

# Add local/bin in home dir for pip3
export PATH="$PATH:~/.local/bin"

# Add /go/bin to path for Golang binaries
export PATH="$PATH:/go/bin"
export PATH="$PATH:/home/leo/go/bin"
export PATH=$PATH:/usr/local/go/bin

# Add .krew (kubectl plugin manager) to PATH
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

_KUBE_PROMPT=true
if [ "${_KUBE_PROMPT}" = true ]; then
  PROMPT='${ret_status} %{$fg[cyan]%}%c%{$reset_color%} (%{$fg[red]%}${ZSH_KUBECTL_CONTEXT}%{$reset_color%}:%{$fg[cyan]%}${ZSH_KUBECTL_NAMESPACE}%{$reset_color%}) $(git_prompt_info)'
else
  PROMPT='${ret_status} %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)'
fi

# added by travis gem
[ -f /.travis/travis.sh ] && source /.travis/travis.sh
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
		admin)
			aws-vault exec --duration=10h admin -- ${@:2}
		;;
		daily)
			aws-vault exec --duration=10h daily-admin -- ${@:2}
		;;
		staging)
			aws-vault exec --duration=8h staging -- ${@:2}
		;;
		break-glass)
			aws-vault exec --duration=1h break-glass-admin -- ${@:2}
		;;
		read-only)
			aws-vault exec --duration=8h read-only -- ${@:2}
		;;
		personal)
			aws-vault exec --duration=8h personal -- ${@:2}
		;;
		*)
			echo "Unknown profile $1. Exiting."
		;;
		esac
	elif [[ $1 == "login" ]]; then
		aws-vault login --duration=8h daily 
	else
		echo "No command detected. Exiting."
	fi
}

# Add colour to manpages
function man() {
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
