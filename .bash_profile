source ~/.git-completion.bash

git config --global --unset http.proxy
git config --global --unset https.proxy

# Git branch in prompt.
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

export PS1="\W\[\033[32m\]\$(parse_git_branch)\[\033[00m\] $ "

alias kill_3000="~/Code/scripts/kill_processes_on_port.rb 3000"
alias switch="~/Code/scripts/switch_branch.rb"
