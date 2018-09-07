#!/bin/bash

list="profile "

# Various commands: directories
echo "Setting directories"
com="elinks mutt newsbeuter aptitude irssi"
for d in $com
do
  echo -n "  Checking $d.."
  command -v $d >/dev/null 2>&1
  if [ $? -eq 0 ]
  then
    echo " ok."
    list+="$d "
  else
    echo " $d is not installed"
  fi
done

# Various commands: rc files
echo "Setting RC files"
com="top conky bash zsh mutt tig"
for d in $com
do
  echo -n "  Checking $d.."
  command -v $d >/dev/null 2>&1
  if [ $? -eq 0 ]
  then
    echo " ok."
    list+="${d}rc "
  else
    echo " $d is not installed"
  fi
done

# Various commands: .conf files
echo "Setting conf files"
com="surfraw tmux"
for d in $com
do
  echo -n "  Checking $d.."
  command -v $d >/dev/null 2>&1
  if [ $? -eq 0 ]
  then
    echo " ok."
    list+="${d}.conf "
  else
    echo " $d is not installed"
  fi
done

# more bash
echo -n "Setting bash_spec.."
command -v bash > /dev/null 2>&1
if [ $? -eq 0 ]
then
  touch ~/.bashrc_spec
  list+="aliases_shell "
  echo " ok."
fi

# more mutt
echo -n "Setting mailcap.."
command -v mutt > /dev/null 2>&1
if [ $? -eq 0 ]
then
  list+="mailcap "
  echo " ok."
fi

# Setting oh-my-zsh
omz=oh-my-zsh
echo -n "Setting oh-my-zsh.."
command -v zsh > /dev/null 2>&1
if [ $? -eq 0 ]
then
  list+="oh-my-zsh "
  echo " ok."
else
  echo " zsh not installed"
fi

# Git
echo -n "Setting git.."
command -v git > /dev/null 2>&1
if [ $? -eq 0 ]
then
  echo " ok."
  list+="gitconfig gitignore_global "
else
  echo " git not installed"
fi

# Set the links
echo "Setting all links"
for file in `echo $list`
do
  echo -n " Setting $file.."
  if [ -L ~/.$file ]
  then
    rm -f ~/.$file
  fi

  if [ ! -e ~/.$file ]
  then
    ln -s $PWD/$file ~/.$file
    echo " ok."
  else
    diff -q ~/.$file $file
  fi
done

# Zsh config
command -v zsh > /dev/null 2>&1
if [ $? -eq 0 ]
then
  echo -n "Setting oh-my-zsh config.."
  config_omz=custom/bilbo.zsh-theme
  if [ -e ~/.$omz ]
  then

    if [ -L $omz/$config_omz ]
    then
      rm -f $omz/$config_omz
    fi

    if [ ! -e $omz/$config_omz ]
    then
      ln -s $PWD/$omz-pers/$config_omz $omz/$config_omz
      echo " ok."
    else
      diff -q $PWD/$omz-pers/$config_omz $omz/$config_omz
      echo " ERROR."
    fi

  else
    echo "~/.$omz does not exists"
  fi
fi

# Seting vim config
command -v vim >/dev/null 2>&1
if [ $? -eq 0 ]
then
  echo "Setting vim config.."
  if [ -e ~/.vim ]
  then
    cd vim_settings
    echo " Running vim_settings/set_links.sh.."
    ./set_links.sh
    cd ..
  fi
fi

# Adapting to the current situations
command -v git > /dev/null 2>&1
if [ $? -eq 0 ]
then
  echo -n "Setting git.."
  case `git --version | awk '{ print $3 }'` in
    2.*)  sed -i 's/tree.*$/tree = log --pretty=\\"format:%C(auto)%h %ad%d [%aN, %G?] - %s %N\\" --all --decorate --graph --color --date=short/' gitconfig
          echo " git v2.. ok."
          ;;
    1.7*) sed -i 's/tree.*$/tree = log --pretty=oneline --decorate --all --abbrev-commit --graph --color/' gitconfig
          echo " git v1.7.. ok."
          ;;
    *)    echo " Git version unknown. Please check how it can be implemented in your local setup."
          ;;
  esac
fi
