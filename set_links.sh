#!/bin/bash

#dir= ~/cfg_backup_`date +%F`
#mkdir $dir

# Simlink single files basic files
for file in aliases_shell bashrc toprc profile
#for file in `find * -maxdepth 0 -type f -not -path ".git" -not -name "*.root" -not -name "set_links.sh" -not -name "*.md" -not -name "pre-push"`
do
  echo "Setting ~/.$file..."
  if [ -L ~/.$file ]
  then
    rm -f ~/.$file
    ln -s $PWD/$file ~/.$file
  else
    if [ ! -e ~/.$file ]
    then
      ln -s $PWD/$file ~/.$file
    else
      diff -q ~/.$file $file
    fi
  fi
done

# tmux
command -v tmux > /dev/null 2>&1
if [ $? -eq 0 ]
then
  echo "Setting ~/.tmux.conf.."
  if [ -L ~/.tmux.conf ]
  then
    rm -f ~/.tmux.conf
    ln -s $PWD/tmux.conf ~/.tmux.conf
  else
    if [ ! -e ~/.tmux.conf ]
    then
      ln -s $PWD/tmux.conf ~/.tmux.conf
    else
      diff -q ~/.tmux.conf tmux.conf
    fi
  fi
else
  echo "tmux not installed"
fi

# Simlink directories
dirs='aptitude elinks newsbeuter irssi mutt'
for d in $dirs
do
  echo "Setting $d.."
  command -v $d > /dev/null 2>&1
  if [ $? -eq 0 ]
  then

    echo " Setting $d.."

    if [ ! -e ~/.$d ]
    then
      mkdir ~/.$d
    fi

    for file in `find $d -type f`
    do
      echo " Update: $file"
      if [ -L ~/.$file ]
      then
	rm -f ~/.$file
	ln -s $PWD/$file ~/.$file
      else
	if [ ! -e ~/.$file ]
	then
	  ln -s $PWD/$file ~/.$file
	else
	  diff -q ~/.$file $file
	fi
      fi
    done
  else
    echo " $d is not installed"
  fi
done

# Setting oh-my-zsh
omz=~/.oh-my-zsh
echo "Setting oh-my-zsh.."
command -v zsh > /dev/null 2>&1
if [ $? -eq 0 ]
then

  if [ -L ~/.zshrc ]
  then
    rm -f ~/.zshrc
    ln -s $PWD/zshrc ~/.zshrc
  else
    if [ ! -e ~/.zshrc ]
    then
      ln -s $PWD/zshrc ~/.zshrc
    else
      diff -q ~/.zshrc zshrc
    fi
  fi

  if [ -L $omz ]
  then
    rm -f $omz
  fi
  if [ ! -e $omz ]
  then
    ln -s $PWD/oh-my-zsh $omz
    if [ ! -e $omz/custom/bilbo.zsh-theme ]
    then
      ln -s $PWD/oh-my-zsh-pers/custom/bilbo.zsh-theme $omz/custom/bilbo.zsh-theme
    fi
  else
    echo "$omz is already present and not a soft link"
    diff -q $omz $PWD/oh-my-zsh
  fi
else
  echo " zsh not installed"
fi

# Seting vim config
echo "Setting vimrc.."
command -v vim >/dev/null 2>&1
if [ $? -eq 0 ]
then
  if [ -L ~/.vimrc ]
  then
    rm -f ~/.vimrc
  fi
  if [ ! -e ~/.vimrc ]
  then
    ln -s $PWD/vim_settings/vimrc ~/.vimrc
  else
    diff -q ~/.vimrc vim_settings/vimrc
  fi

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
for file in gitconfig gitignore_global
do
  if [ -L ~/.$file ]
  then
    rm -f ~/.$file
    ln -s $PWD/$file ~/.$file
  else
    if [ ! -e ~/.$file ]
    then
      ln -s $PWD/$file ~/.$file
    else
      diff -q ~/.$file $file
    fi
  fi
done

case `git --version | awk '{ print $3 }'` in
  2.*)	sed -i 's/tree.*$/tree = log --pretty=\\"format:%C(auto)%h %ad%d [%aN, %G?] - %s %N\\" --all --decorate --graph --color --date=short/' gitconfig
    ;;
  1.7*) sed -i 's/tree.*$/tree = log --pretty=oneline --decorate --all --abbrev-commit --graph --color/' gitconfig
    ;;
  *) echo " Git version unknown. Please check how it can be implemented in your local setup."
    ;;
esac
