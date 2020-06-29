source ~/.git-completion.bash

git config --global --unset http.proxy
git config --global --unset https.proxy

# Git branch in prompt.
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Setting ag as the default source for fzf
export FZF_DEFAULT_COMMAND='ag --ignore .git -g ""'

# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export PS1="\W\[\033[32m\]\$(parse_git_branch)\[\033[00m\] $ "

alias kill_3000="~/Code/scripts/kill_processes_on_port.rb 3000"
alias switch="~/Code/scripts/switch_branch.rb"
alias clean="git branch --merged master | grep -v '\* master' | xargs -n 1 git branch -d"
