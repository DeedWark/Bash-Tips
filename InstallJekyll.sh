#!/usr/bin/env bash

if [ $UID -eq 0 ]; then
	echo "You are not the right guy! (Try it with sudo)"
	exit 1
fi

apt-get install -y ruby-full build-essential zlib1g-dev

echo '# Install Ruby Gems to ~/gems' >> ~/.bashrc
echo 'export GEM_HOME="$HOME/gems"' >> ~/.bashrc
echo 'export PATH="$HOME/gems/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

gem install jekyll bundler

echo -e "Create a new project:
-> jekyll new myproject
-> cd myproject
-> bundle exec jekyll serve
# => Now browse to http://localhost:4000"
