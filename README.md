# Lucas' .bashrc

This is [my `.bashrc` file](.bashrc). Feel free to clone/copy and reuse as you like.

I use two additional scripts for easier git usage, both of which are placed in my `~/bashscripts` directory. You can copy/clone these scripts from their original repositories (linked below).

* [`git-completion.bash`](https://github.com/git/git/blob/master/contrib/completion/git-completion.bash): This enables git auto-completion on my git aliases. This allows me to press the `tab` key after entering a git alias to get things like branch names auto-completed.
* [`bash-git-prompt`](https://github.com/magicmonty/bash-git-prompt): A very handy bash prompt customisation that shows the status of the repository (things like the current branch, number of staged/modified/untracked files, etc.).
  
  I have also included my custom theme files for the `bash-git-prompt`:
  * [The most recent one](bashscripts/bash-git-prompt/themes/Lucas_bullettrain_tags.bgptheme)  is for a dark background, and is inspired by the [bullet train theme](https://github.com/caiogondim/bullet-train-oh-my-zsh-theme) for `oh-my-zsh`. This theme requires a Powerline patched font.
  ![git prompt screenshot](gitprompt_Lucas_bullettrain_tags.png)
  * [The other theme](bashscripts/bash-git-prompt/themes/Single_line_Lucas.bgptheme) , is my original one-line light background theme that I used for a while.
  ![git prompt screenshot](gitprompt.png)

