#!/usr/bin/env bash

if [ $UID -eq 0 ]; then
	echo "You are not the right guy! (Try it with sudo)"
	exit 1
fi

apt-get install -y ruby-full build-essential zlib1g-dev

#Detec shell
sh=${SHELL}
case ${sh} in
	*bash* ) rc="~/.bashrc";;
	*zsh* ) rc="~/.zshrc";;
	* ) rc="~/.bashrc";;
esac

echo "Add commands in ${rc} ..."
echo '# Install Ruby Gems to ~/gems' >> ${rc}
echo 'export GEM_HOME="$HOME/gems"' >> ${rc}
echo 'export PATH="$HOME/gems/bin:$PATH"' >> ${rc}
source ${rc}

gem install jekyll bundler

echo -e "\nCreate a new project:
-> jekyll new myproject
-> cd myproject
-> bundle exec jekyll serve
# => Now browse to http://localhost:4000"
