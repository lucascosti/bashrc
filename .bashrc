# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

######## Lucas' stuff below here ########

# set length of pwd shown on prompt
export PROMPT_DIRTRIM=2

# Normal prompt config (this will be overriden by bash-git-prompt; see below)
# For main colours used in the prompt, see the bash-git-prompt theme.
green="\[\e[32m\]"
PS1="${green}[\u@\h \W] \$${normal} "

# for root, make it red (put this in /root/.bashrc):
# PS1="${red}[\u@\h \W]#${normal} "

# Regular aliases
alias ffs='sudo "$BASH" -c "$(history -p !!)"'
alias bi='brew install'
alias br='brew uninstall'
alias bu='brew update'
# Color fix for home monitor: see: https://lucascosti.com/blog/2016/08/monitor-colour-problems-over-hdmi/
alias hdmi-color-fix='sh ~/bashscripts/hdmi-colour-fix.sh'

# Git
## Git aliases
alias g='git'
alias gfu='git fetch upstream'
alias gfo='git fetch origin'
alias gr='git rebase'
alias gpull='git pull'
alias gs='git status'
alias gc='git checkout'
alias gl="git log --pretty=format:'%Cblue%h%Creset%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)%an%Creset' --abbrev-commit --date=relative"
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
alias gcommam='git add -A && git commit -m'
alias gcomma='git add -A && git commit'
alias gcommend='git add -A && git commit --amend --no-edit'
alias gm='git merge'
alias gcp='git cherry-pick'
alias gpoh='git push origin HEAD'
alias gcd='cd ~/repos/'
### From https://docs.gitlab.com/ee/user/project/merge_requests/#checkout-merge-requests-locally : e.g. gcmr upstream 12345
gcmr() { git fetch $1 merge-requests/$2/head:mr-$1-$2 && git checkout mr-$1-$2; }
### This function prunes references to deleted remote branches and
### deletes local branches that have been merged and/or deleted from the remotes.
### It is intended to be run when on a master branch, and warns when it isn't.
gclean (){
  local BRANCH=`git rev-parse --abbrev-ref HEAD`
  # Warning if not on a master* branch
  if [[ $BRANCH != master* ]]
  then
    echo -e "\e[91m!! WARNING: It looks like you are not on a master branch !!\e[39m"
    read -r -p "Are you sure you want to continue? [y/N] " response
    if ! [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
    then
      echo "Aborted. Nothing was changed."
      return 1
    fi
  fi
  echo "Simulating a clean on $BRANCH ..." \
  && echo "===== 1/2: simulating pruning origin =====" \
  && git remote prune origin --dry-run \
  && echo "===== 2/2: simulating cleaning local branches merged to $BRANCH =====" \
  && git branch --merged $BRANCH | grep -v "^\**\s*master"  \
  && echo "=====" \
  && echo "Simulation complete."
  read -r -p "Do you want to proceed with the above clean? [y/N] " response
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
  then
    echo "Running a clean on $BRANCH ..."
    echo "===== 1/2: pruning origin =====" \
    && git remote prune origin \
    && echo "===== 2/2: cleaning local branches merged to $BRANCH =====" \
    && git branch --merged $BRANCH | grep -v "^\**\s*master" | xargs git branch -d \
    && echo "=====" \
    && echo "Clean finished."
  else
    echo "Aborted. Nothing was changed."
  fi
}
### Sync local and origin branch from a remote: runs a fetch from specified remote + rebase local + push to origin
gsync (){
  local BRANCH=`git rev-parse --abbrev-ref HEAD`
  echo "Syncing the current branch: $BRANCH"
  echo "===== 1/3: fetching $1 =====" \
  && git fetch $1 \
  && echo "===== 2/3: rebasing $BRANCH =====" \
  && git rebase $1/$BRANCH \
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
    && echo "===== 2/2: git clean -fd \$(git rev-parse --show-toplevel) =====" \
    && git clean -fd $(git rev-parse --show-toplevel)
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
  __git_complete gr _git_rebase
  __git_complete gl _git_log
  __git_complete ga _git_add
  __git_complete gd _git_diff
  __git_complete gcom _git_commit
  __git_complete gcomma _git_commit
  __git_complete gcmr _git_ls_remote
  __git_complete gpull _git_pull
  __git_complete gsync _git_fetch
fi

## Custom git prompt configuration https://github.com/magicmonty/bash-git-prompt
  # Set config variables first
  GIT_PROMPT_ONLY_IN_REPO=0

  # GIT_PROMPT_FETCH_REMOTE_STATUS=0   # uncomment to avoid fetching remote status

  # Lucas: change fetch interval to 60 minutes (default is 5)
  GIT_PROMPT_FETCH_TIMEOUT=60

  # as last entry source the gitprompt script
  GIT_PROMPT_THEME=Lucas_bullettrain_tags # use custom .git-prompt-colors.sh
  source ~/bashscripts/bash-git-prompt/gitprompt.sh
  
#########
# Required for GitHub docs builds bootstrap
eval "$(rbenv init -)"
eval "$(nodenv init -)"

# Build GitHub dev docs
alias bcurrent='script/server'
# Runs a backport then a build. 
bbackport() {
  # if there a no arguments, build all versions. For one or more specified versions as arguments, build those specified.
  if [ -z "$1" ]
    then
      versions=( 2.16 2.15 2.14 2.13 )
    else
      versions=( "$@" )
  fi
  for v in "${versions[@]}"
    do script/enterprise-backport $v
  done
  bcurrent
}
