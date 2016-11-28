#!/bin/bash

#dir= ~/cfg_backup_`date +%F`
#mkdir $dir

# Simlink single files
for file in `find * -maxdepth 0 -type f -not -path ".git/" -not -name "*.root" -not -name "set_links.sh"`
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

# Simlink directories
dirs='aptitude elinks newsbeuter irssi'
for d in $dirs
do
  echo "dir: $d"

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
done

# Setting oh-my-zsh
omz=~/.oh-my-zsh
if [ -L $omz ]
then
  rm -f $omz
fi
if [ ! -e $omz ]
then
  ln -s $PWD/oh-my-zsh $omz
  ln -s $PWD/oh-my-zsh-pers/custom/bilbo.zsh-theme $omz/custom/bilbo.zsh-theme
else
  echo "$omz is already present and not a soft link"
  diff -q $omz $PWD/oh-my-zsh
fi

# Seting vim config
if [ -L ~/.vimrc ]
then
  rm -f ~/.vimrc
  ln -s $PWD/vim_settings/vimrc ~/.vimrc
else
  if [ ! -e ~/.vimrc ]
  then
    ln -s $PWD/vim_settings/vimrc ~/.vimrc
  else
    diff -q ~/.vimrc vim_settings/vimrc
  fi
fi

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
  echo "Found links:"
  find . -type l -ls
  find . -type l -delete
  cd -
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

# Adapting to the current situations
case `git --version | awk '{ print $3 }'` in
  2.3*)	sed -i 's/tree.*$/tree = log --pretty=\\"format:%C(auto)%h %ad%d [%aN, %G?] - %s %N\\" --all --decorate --graph --color --date=short/' gitconfig
    ;;
  1.7*) sed -i 's/tree.*$/tree = log --pretty=oneline --decorate --all --abbrev-commit --graph --color/' gitconfig
    ;;
  *) echo "Git version unknown. Please check how it can be implemented in your local setup."
    ;;
esac
