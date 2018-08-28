#!/bin/bash

echo -n "Please enter your user/short name: "
read username

echo -n "Please enter your email address: "
read email

echo -n "Please enter your full name: "
read fullname

echo -n "Please enter your company name: "
read company

list_of_files="vim_settings/vim/config gitconfig vim_settings/vim/plugins/cvim/c-support/templates/Templates irssi/config muttrc"

for file in $list_of_files
do
  echo -n "Updating $file... "
  sed -i "s/|FULLNAME|/$fullname/g" $file
  sed -i "s/|USERNAME|/$username/g" $file
  sed -i "s/|EMAIL|/$email/g" $file
  sed -i "s/|COMPANY|/$company/g" $file
  echo " done. Please check."
done
