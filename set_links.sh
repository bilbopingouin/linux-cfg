#!/bin/bash

list="profile "

echo "Checking bash.."
command -v bash > /dev/null 2>&1
if [ $? -eq 0 ]
then
  touch ~/.bashrc_spec
  list+="aliases_shell bashrc "
else
  echo " bash not installed"
fi

echo "Checking top.."
command -v top > /dev/null 2>&1
if [ $? -eq 0 ]
then
  listi+="toprc "
else
  echo " top not installed"
fi

# tmux
echo "Checking tmux.."
command -v tmux > /dev/null 2>&1
if [ $? -eq 0 ]
then
  list+="tmux.conf "
else
  echo " tmux not installed"
fi

# Conky
echo "Checking conky.."
command -v conky >/dev/null 2>&1
if [ $? -eq 0 ]
then
  list+="conkyrc "
else
  echo " conky is not installed"
fi

# Surfraw
echo "Checking surfraw.."
command -v surfraw >/dev/null 2>&1
if [ $? -eq 0 ]
then
  list+="surfraw.conf "
else
  echo " surfraw is not installed"
fi


# Simlink directories
dirs='aptitude elinks newsbeuter irssi mutt'
for d in $dirs
do
  echo "Checking $d.."
  command -v $d > /dev/null 2>&1
  if [ $? -eq 0 ]
  then

    if [ ! -e ~/.$d ]
    then
      echo " Creating ~/.$d"
      mkdir ~/.$d
    fi

    for file in `find $d -type f`
    do
      list+="$file "
    done
  else
    echo " $d is not installed"
  fi
done

# More mutt
command -v mutt > /dev/null 2>&1
if [ $? -eq 0 ]
then
  list+="muttrc mailcap "
fi

# Setting oh-my-zsh
omz=~/.oh-my-zsh
echo "Checking oh-my-zsh.."
command -v zsh > /dev/null 2>&1
if [ $? -eq 0 ]
then
  list+="zshrc "
  list+="oh-my-zsh "
else
  echo " zsh not installed"
fi

# Git
echo "Checking git.."
command -v git > /dev/null 2>&1
if [ $? -eq 0 ]
then
  list+="gitconfig gitignore_global "
else
  echo " git not installed"
fi

# vim
echo "Checking vim.."
command -v vim >/dev/null 2>&1
if [ $? -eq 0 ]
then
  list+="vimrc "
fi



# Set the links
echo "Setting all links"
for file in `echo $list`
do
  echo " Setting $file.."
  if [ -L ~/.$file ]
  then
    rm -f ~/.$file
  fi

  if [ ! -e ~/.$file ]
  then
    ln -s $PWD/$file ~/.$file
  else
    diff -q ~/.$file $file
  fi

done

# Zsh config
command -v zsh > /dev/null 2>&1
if [ $? -eq 0 ]
then
  echo "Setting oh-my-zsh.."
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
    else
      diff -q $PWD/$omz-pers/$config_omz $omz/$config_omz
    fi
  fi
fi

# Seting vim config
command -v vim >/dev/null 2>&1
if [ $? -eq 0 ]
then
  echo "Setting vim.."
  if [ -L ~/.vim ]
  then 
    echo " Delete ~/.vim link"
    rm -f ~/.vim
  fi
  if [ ! -e ~/.vim ]
  then
    echo " Set ~/.vim link"
    ln -s $PWD/vim_settings/vim ~/.vim
    
    cd ~/.vim
    echo " The following soft-links will be deleted:"
    find . -type l -ls | awk '{print "  ",$11}'
    find . -type l -delete
    cd - > /dev/null
    # Solarized
    ln -s  ~/.vim/plugins/solarized/vim-colors-solarized-master/colors/solarized.vim  ~/.vim/colors/solarized.vim
    ln -s  ~/.vim/plugins/solarized/vim-colors-solarized-master/doc/solarized.txt	    ~/.vim/doc/solarized.txt	
    # Undotree
    ln -s  ~/.vim/plugins/undotree/undotree-rel_4.3/./plugin/undotree.vim		    ~/.vim/plugin/undotree.vim 
    ln -s  ~/.vim/plugins/undotree/undotree-rel_4.3/./syntax/undotree.vim		    ~/.vim/syntax/undotree.vim 
    # Echo func
    ln -s  ~/.vim/plugins/echofunc/echofunc.vim					    ~/.vim/plugin/echofunc.vim 
    # fugitive
    ln -s  ~/.vim/plugins/fugitive/vim-fugitive/plugin/fugitive.vim		    ~/.vim/plugin/fugitive.vim 
    ln -s  ~/.vim/plugins/fugitive/vim-fugitive/doc/fugitive.txt			    ~/.vim/doc/fugitive.txt	
    # vim games
    for file in `find ~/.vim/plugins/vim-games/plugin/* -maxdepth 0`; do ln -s $file $(echo $file | sed -n 's/plugins\/vim-games\///p'); done
    # vim-surround
    ln -s ~/.vim/plugins/vim-surround/plugin/surround.vim				    ~/.vim/plugin/surround.vim
    ln -s ~/.vim/plugins/vim-surround/doc/surround.txt				    ~/.vim/doc/surround.txt
  else
    echo "~/.vim should be set manually: not a softlink"
  fi

  if [ ! -e ~/.undodir ]
  then
    mkdir ~/.undodir
  fi
else
  echo " vim is not installed"
fi

# Adapting to the current situations
echo "Setting git.."
case `git --version | awk '{ print $3 }'` in
  2.*)	sed -i 's/tree.*$/tree = log --pretty=\\"format:%C(auto)%h %ad%d [%aN, %G?] - %s %N\\" --all --decorate --graph --color --date=short/' gitconfig
    ;;
  1.7*) sed -i 's/tree.*$/tree = log --pretty=oneline --decorate --all --abbrev-commit --graph --color/' gitconfig
    ;;
  *) echo " Git version unknown. Please check how it can be implemented in your local setup."
    ;;
esac
