# Bash config specific for the computer
if [ -e ~/.bashrc_spec ]
then
  . ~/.bashrc_spec
fi

case $- in
  *i*)	

  # A list of aliases used
  if [ -e ~/.aliases_shell ]
  then
    . ~/.aliases_shell
  fi

  # users connected
  mesg n							#No write possible

  set -o noclobber #-o ignoreeof #ctrl-d to leave the shell

  if [ -n "$BASH" ]
  then	# bash
    # export PS1="\[$(tput setaf 0)$(tput setab 1)\]\u@\h:\w # \[$(tput sgr0)\]" # ROOT prompt
    PS1='\[$(tput setaf 4)$(tput bold)\]\h\[$(tput sgr0)\]:\[$(tput setaf 2)\]\w \[$(tput sgr0)\]\$ '
    #PS1='\['`tput bold`'\]\h:\w \$ \['`tput sgr0`'\]'
    FIGNORE='.o:~'
    history_control=ignoredups command_oriented_history=1
    export HISTCONTROL=ignorespace:ignoredups
    alias r='fc -e -'
    HISTFILESIZE=1000
  elif [ -n "$ZSH_VERSION" ]
  then	# zsh
    # aliases
    alias nohup='nohup '
    # directory navigation
    DIRSTACKSIZE=5
    setopt auto_pushd pushd_ignore_dups
    # history
    HISTFILE=~/.zsh_history SAVEHIST=1000
    setopt extended_history hist_ignore_dups append_history
    # completion
    setopt auto_list auto_param_slash auto_remove_slash
    compctl -l '' exec man nohup time type whence
    compctl -g '*(-/)' cd rmdir
    compctl -v unset typeset declare vared readonly export integer
    FIGNORE='.o:~'
    bindkey '^[^[' expand-or-complete
    bindkey -as '\t' 'a\t'
    # misc
    setopt sh_word_split extended_glob numeric_glob_sort correct
    setopt interactive_comments
    bindkey -v
    bindkey "$(echotc kD)" delete-char
    bindkey -a "$(echotc kD)" vi-delete-char
    bindkey "$(echotc kh)" beginning-of-line
    bindkey "$(echotc @7)" end-of-line 2>/dev/null
    bindkey "$(echotc kl)" backward-char
    bindkey "$(echotc kr)" forward-char
    bindkey "$(echotc ku)" up-line-or-history
    bindkey "$(echotc kd)" down-line-or-history
    bindkey '^K' kill-line

    PS1='%S%m:%30<...<%~ %(#.#.>)%s '
    [ "$TERM" = "hp" -o "$TERM" = "hpterm" ] &&
    PS1=%{`echotc ks`%}$PS1
  else	# ksh
    set -o emacs
    PS1=`hostname`:'$PWD $ '
    alias __A=`echo '\020'` # ^P
    alias __B=`echo '\016'` # ^N
    alias __D=`echo '\002'` # ^B
    alias __C=`echo '\006'` # ^F
    alias __H=`echo '\001'` # ^H
    alias __P=`echo '\004'` # ^D
    alias __q=`echo '\005'` # ^E
  fi

  HISTSIZE=1000 CDPATH=:$HOME

esac
