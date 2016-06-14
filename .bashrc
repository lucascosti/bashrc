# .bashrc
#Lucas colors (also used in bash-git-prompt)
black="\[\e[0;30m\]"
darkgray="\[\e[1;30m\]"
red="\[\e[0;31m\]"
lightred="\[\e[1;31m\]"
green="\[\e[0;32m\]"
lightgreen="\[\e[1;32m\]"
brown="\[\e[0;33m\]"
yellow="\[\e[1;33m\]"
blue="\[\e[0;34m\]"
lightblue="\[\e[1;34m\]"
purple="\[\e[0;35m\]"
lightpurple="\[\e[1;35m\]"
cyan="\[\e[0;36m\]"
lightcyan="\[\e[1;36m\]"
lightgray="\[\e[0;37m\]"
white="\[\e[1;37m\]"
normal="\[\e[0;00m\]"
orange="\[\e[38;5;166m\]"
lightmagenta="\[\e[38;5;95m\]"

# Normal prompt config (overriden by bash-git-prompt when in git repos)
PS1="${green}[\u@\h \W] \$${normal} "


# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

alias ffs='sudo "$BASH" -c "$(history -p !!)"'

# Publican and brew aliases
alias brewstart="rhpkg publican-build --lang en-US"
alias cspbuild="csprocessor build"
alias pubbuild="publican build --langs en-US --formats html-single"

# CCS repo tools
## Easy grep to exclude build folters. e.g.: ggrep infinispan
ggrep () { grep "$@" -iR --exclude-dir={build,html}; }
## Opens a build file
alias previewdoc="firefox build/tmp/en-US/html-single/index.html"

# Git
## Git aliases
alias g='git'
alias gs='git status'
alias ga='git add'
alias gfu='git fetch upstream'
alias gr='git rebase upstream/master'
alias gpom='git push origin master'
alias gc='git checkout'
alias gl="git log --pretty=format:'%Cblue%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
alias gd='git diff'
alias gnewbranch='git checkout -b'
alias gnb='git checkout -b'
alias gcom='git commit'
alias gcommam='git commit -am'
alias gcomma='git commit -a'
alias grmbranch='git branch -d'
alias gbranches='git branch -a'
alias gpoh='git push origin HEAD'
### This deletes local branches that have been merged and deleted from origin
alias gclean="git remote prune origin; git branch --merged master | grep -v 'master$' | xargs git branch -d"
alias gdryclean="git remote prune origin --dry-run; git branch --merged master | grep -v 'master$'"
### Sync local and origin master from upstream: runs a fetch + rebase + push
alias gsync='echo "===== 1/3: fetching upstream =====" \
&& gfu \
&& echo "===== 2/3: rebasing master =====" \
&& gr \
&& echo "===== 3/3: pushing to origin =====" \
&& gpom'

## Function to take git interactive rebase argument. e.g.: gir 2
gri() { git rebase -i HEAD~$1; }
gir() { git rebase -i HEAD~$1; }


## git bash completion for aliases
# To Setup:
# 1) Save the .git-completion.bash file found here:
#    https://github.com/git/git/blob/master/contrib/completion/git-completion.bash
# 2) Add the following lines to your .bash_profile, be sure to reload (for example: source ~/.bash_profile) for the changes to take effect:
if [ -f ~/bashscripts/git-completion.bash ]; then
  . ~/bashscripts/git-completion.bash
  
  # Add git completion to aliases
  __git_complete g __git_main
  __git_complete gc _git_checkout
  __git_complete gnb _git_checkout
  __git_complete gnewbranch _git_checkout
  __git_complete gm __git_merge
  __git_complete grmbranch _git_branch
  __git_complete gl _git_log
  __git_complete ga _git_add
  __git_complete gd _git_diff
fi

## Custom git prompt configuration https://github.com/magicmonty/bash-git-prompt
   # Set config variables first
   GIT_PROMPT_ONLY_IN_REPO=1

   # GIT_PROMPT_FETCH_REMOTE_STATUS=0   # uncomment to avoid fetching remote status

   # as last entry source the gitprompt script
   GIT_PROMPT_THEME=Single_line_Lucas # use custom .git-prompt-colors.sh
source ~/bashscripts/bash-git-prompt/gitprompt.sh
