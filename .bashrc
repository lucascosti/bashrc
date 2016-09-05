# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=


######## Lucas' stuff below here ########

# Lucas colors (mainly used in bash-git-prompt)
# See http://askubuntu.com/a/558422, http://misc.flogisoft.com/bash/tip_colors_and_formatting for a good list
## Foreground colours
normal="\[\e[39m\]"
black="\[\e[30m\]"
darkgray="\[\e[90m\]"
red="\[\e[31m\]"
lightred="\[\e[91m\]"
green="\[\e[32m\]"
lightgreen="\[\e[92m\]"
yellow="\[\e[33m\]"
blue="\[\e[34m\]"
lightblue="\[\e[34m\]"
brightblue="\[\e[38;5;27m\]"
stashblue="\[\e[38;5;26m\]"
purple="\[\e[35m\]"
lightpurple="\[\e[35m\]"
maroon="\[\e[38;5;88m\]"
cyan="\[\e[36m\]"
lightcyan="\[\e[36m\]"
lightgray="\[\e[37m\]"
white="\[\e[37m\]"
orange="\[\e[38;5;166m\]"
lightmagenta="\[\e[38;5;95m\]"
## Background colours
bg_normal="\[\e[49m\]"
bg_black="\[\e[40m\]"
bg_red="\[\e[41m\]"
bg_green="\[\e[42m\]"
bg_yellow="\[\e[43m\]"
bg_blue="\[\e[44m\]"
bg_magenta="\[\e[45m\]"
bg_cyan="\[\e[46m\]"
bg_lgray="\[\e[47m\]"
bg_gray="\[\e[100m\]"
bg_lred="\[\e[101m\]"
bg_lgreen="\[\e[102m\]"
bg_lyellow="\[\e[103m\]"
bg_lblue="\[\e[104m\]"
bg_lmagenta="\[\e[105m\]"
bg_lcyan="\[\e[106m\]"
bg_white="\[\e[107m\]"

# set length of pwd shown on prompt
export PROMPT_DIRTRIM=2

# Normal prompt config (this will be overriden by bash-git-prompt; see below)
PS1="${green}[\u@\h \W] \$${normal} "

# for root, make it red (put this in /root/.bashrc):
# PS1="${red}[\u@\h \W]#${normal} "

# Regular aliases
alias ffs='sudo "$BASH" -c "$(history -p !!)"'
alias sdnfu='sudo dnf update'
alias sdnfur='sudo dnf update --refresh'
alias sdnfi='sudo dnf install'
alias sdnfr='sudo dnf remove'
# Color fix for home monitor: see: https://lucascosti.com/blog/2016/08/monitor-colour-problems-over-hdmi/
alias hdmi-color-fix='sh ~/bashscripts/hdmi-colour-fix.sh'

# Publican and brew aliases
alias brewstart="rhpkg publican-build --lang en-US"
alias cspbuild="csprocessor build"
alias pubbuild="publican build --langs en-US --formats html-single"

# CCS repo aliases
## Easy grep to exclude build folders. e.g.: ggrep infinispan
ggrep () { grep "$@" -iR --exclude-dir={build,html}; }
# Build a guide when in a guide folder
alias bg='./buildGuide.sh'
## Opens a locally-built doc
alias previewdoc="firefox build/tmp/en-US/html-single/index.html"

# Git
## Git aliases
alias g='git'
alias gfu='git fetch upstream'
alias gfo='git fetch origin'
alias gr='git rebase upstream/master'
alias gs='git status'
alias gc='git checkout'
alias gl="git log --pretty=format:'%Cblue%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)%an%Creset' --abbrev-commit --date=relative"
alias gbranches='git branch -a'
alias gnb='git checkout -b'
alias gnewbranch='git checkout -b'
alias grmbranch='git branch -d'
alias gd='git diff'
alias gss='git stash save'
alias gsp='git stash pop'
alias gsl='git stash list'
alias ga='git add'
alias gaa='git add -A'
alias gcom='git commit'
alias gcommam='git commit -am'
alias gcomma='git commit -a'
alias gm='git merge'
alias gpoh='git push origin HEAD'
alias gpom='git push origin master'
### This deletes local branches that have been merged and/or deleted from origin
alias gclean="git remote prune origin; git branch --merged master | grep -v 'master$' | xargs git branch -d"
alias gdryclean="git remote prune origin --dry-run; git branch --merged master | grep -v 'master$'"
### Sync local and origin branch from upstream: runs a fetch + rebase + push
gsync (){
    local BRANCH=`git rev-parse --abbrev-ref HEAD`
    echo "Syncing the current branch: $BRANCH"
    echo "===== 1/3: fetching upstream =====" \
    && git fetch upstream \
    && echo "===== 2/3: rebasing $BRANCH =====" \
    && git rebase upstream/$BRANCH \
    && echo "===== 3/3: pushing to origin/$BRANCH =====" \
    && git push origin $BRANCH \
    && echo "=====" \
    && echo "Syncing finished."
}
### Function to take git interactive rebase argument. e.g.: gir 2
gri() { git rebase -i HEAD~$1; }
gir() { git rebase -i HEAD~$1; }
### Function to undo all changes (including stages) back to the last commit, with a confirmation.
gundoall () {
  echo "WARNING: This will delete all untracked files, and undo all changes since the last commit."
  read -r -p "Are you sure? [y/N] " response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
  then
      echo "===== 1/2: git reset --hard HEAD =====" \
      && git reset --hard HEAD \
      && echo "===== 2/2: git clean -fd =====" \
      && git clean -fd
  else
      echo "Aborted. Nothing was changed."
  fi
}


## git bash completion for aliases
# To Setup:
# 1) Save the .git-completion.bash file found here:
#    https://github.com/git/git/blob/master/contrib/completion/git-completion.bash
# 2) Add the following lines to your .bash_profile, be sure to reload (for example: source ~/.bash_profile) for the changes to take effect:
if [ -f ~/bashscripts/git-completion.bash ]; then
  . ~/bashscripts/git-completion.bash
  
  # Add git completion to the aliases: you must manually match each of your aliases to the respective function for the git command defined in git-completion.bash.
  __git_complete g __git_main
  __git_complete gc _git_checkout
  __git_complete gnb _git_checkout
  __git_complete gnewbranch _git_checkout
  __git_complete gm _git_merge
  __git_complete grmbranch _git_branch
  __git_complete gl _git_log
  __git_complete ga _git_add
  __git_complete gd _git_diff
fi

## Custom git prompt configuration https://github.com/magicmonty/bash-git-prompt
  # Set config variables first
  GIT_PROMPT_ONLY_IN_REPO=0

  # GIT_PROMPT_FETCH_REMOTE_STATUS=0   # uncomment to avoid fetching remote status

  # as last entry source the gitprompt script
  GIT_PROMPT_THEME=Lucas_bullettrain_tags # use custom .git-prompt-colors.sh
  source ~/bashscripts/bash-git-prompt/gitprompt.sh
