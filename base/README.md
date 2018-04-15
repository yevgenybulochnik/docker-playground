# Base Image for Tinkering
This is a base dockerfile for tinkering. Installs a few commonly used utilities and then my dotfiles on root. Locale needs to be set for Vim [Nerdtree](https://github.com/scrooloose/nerdtree) to function correctly. Locale can be set with an export to .bashrc or as an `ENV` variable in the docker file 
