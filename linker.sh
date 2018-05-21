#!/bin/bash
# Links everything in home/ to ~/, does sanity checks.
# By Simon Eskildsen (github.com/Sirupsen)
# See: https://github.com/sirupsen/dotfiles/blob/master/linker.sh

function symlink {
  ln -nsf $1 $2
}

for file in home/.[^.]*; do
  path="$(pwd)/$file"
  base=$(basename $file)
  target="$HOME/$(basename $file)"

  if [[ -h $target && ($(readlink $target) == $path)]]; then
    echo -e "\x1B[32m~/$base is symlinked to your dotfiles.\x1B[39m"
  elif [[ -f $target && $(sha256sum $path | awk '{print $2}') == $(sha256sum $target | awk '{print $2}') ]]; then
    echo -e "\x1B[32m~/$base exists and was identical to your dotfile.  Overriding with symlink.\x1B[39m"
    symlink $path $target
  elif [[ -a $target ]]; then
    echo -e "\x1B[33m~/$base exists and differs from your dotfile. Override?  [yn]\x1B[39m"
    read reply
    if [[ $reply =~ ^[yY]$ ]]; then
      symlink $path $target
    fi
  else
    echo -e "\x1B[32m~/$base does not exist. Symlinking to dotfile.\x1B[39m"
    symlink $path $target
  fi
done
