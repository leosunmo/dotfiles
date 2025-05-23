# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH


# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# zmodload zsh/zprof
plugins=(
  git
  docker
  zsh-kubectl-prompt
)

source $ZSH/oh-my-zsh.sh

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

# User configuration

# JAVA_HOME stuff
if [ $(uname 2> /dev/null) != "Linux" ]; then
export JAVA_HOME=$(/usr/libexec/java_home)
fi

# Go settings
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
	# Bind caps lock to escape
	gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape']"
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
alias dc='docker compose'
alias cat='bat'
alias t='todo.sh'

# Git aliases
alias gpmr='git push --set-upstream origin $(git_current_branch) -o merge_request.create'
# Terraform alias
alias tf='terraform'

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

# STM32 cube programmer path
export PATH="$PATH:/usr/local/STMicroelectronics/STM32Cube/STM32CubeProgrammer/bin"

# Add /go/bin to path for Golang binaries
export PATH="$PATH:/go/bin"
export PATH="$PATH:/home/leo/go/bin"
export PATH=$PATH:/usr/local/go/bin

# Add /usr/local/include for Protobuf
export PATH="$PATH:/usr/local/include"

# Add .krew (kubectl plugin manager) to PATH
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# set up asdf
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

function _kube_prompt() {
if [ "${_KUBE_PROMPT}" = true ] && [ -f ~/.kube/config ]; then
	local _CLUSTER_COLOUR
	# Decide colour based on cluster name
	if [[ $ZSH_KUBECTL_CONTEXT =~ "-sandbox" ]]; then
		_CLUSTER_COLOUR="green"
	elif [[ $ZSH_KUBECTL_CONTEXT =~ "-staging" || $ZSH_KUBECTL_CONTEXT =~ "-engineering" ]]; then
		_CLUSTER_COLOUR="yellow"
	elif [[ $ZSH_KUBECTL_CONTEXT =~ "-prod" ]]; then
		_CLUSTER_COLOUR="red"
	else
		_CLUSTER_COLOUR="red"
	fi

	local cluster_short=${ZSH_KUBECTL_CONTEXT##*_}

	echo "%{$reset_color%}(%{$fg[${_CLUSTER_COLOUR}]%}${cluster_short}%{$reset_color%}:%{$fg[cyan]%}${ZSH_KUBECTL_NAMESPACE}%{$reset_color%}) "
fi
}

_KUBE_PROMPT=true
_PREVIOUS_KUBE_CONTEXT=""
# kprompt enables and disables the kube prompt
function kprompt () {
	if [ ! -f ~/.kube/config ]; then
		echo "No kube config found"
		return
	fi
	if [ "${_KUBE_PROMPT}" = true ]; then
		_KUBE_PROMPT=false
		_PREVIOUS_KUBE_CONTEXT=$(kubectl config current-context)
		kubectl config set-context disabled
		kubectl config use-context disabled
	else
		_KUBE_PROMPT=true
		kubectl config use-context $_PREVIOUS_KUBE_CONTEXT
	fi
}

# Set the git prompt colors and designs. Copied from robbyrussell
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

_GIT_PROMPT=true
function _git_prompt() {
	if [ "${_GIT_PROMPT}" = true ]; then
		echo "$(_omz_git_prompt_info)"
	else
		echo ""
	fi
}

_SCRNSHT_PROMPT=false
# scrnprompt clears the prompt for screenshots
function scrnprompt() {
	if [ "${_SCRNSHT_PROMPT}" = false ]; then
		_SCRNSHT_PROMPT=true
		# remove the Kubernetes prompt
		_KUBE_PROMPT=false
		# remove the git prompt
		_GIT_PROMPT=false
	else
		_SCRNSHT_PROMPT=false
		# remove the Kubernetes prompt
		_KUBE_PROMPT=true
		# remove the git prompt
		_GIT_PROMPT=true
	fi
}

ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
PROMPT='${ret_status}$(_kube_prompt)%{$fg_bold[cyan]%}%c%{$reset_color%} $(_git_prompt)%{$reset_color%}'

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

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/leo/tmp/google-cloud-sdk/path.zsh.inc' ]; then . '/home/leo/tmp/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/leo/tmp/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/leo/tmp/google-cloud-sdk/completion.zsh.inc'; fi

# Kubectl completion
if [ -f ~/.kube/config ]; then
	source <(kubectl completion zsh)
fi

alias code='code --enable-features=UseOzonePlatform --ozone-platform=wayland'

# jt completion
# source <(jt -c)
