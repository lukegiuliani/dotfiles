#!/usr/bin/env bash
cd "$(dirname "${BASH_SOURCE}")"
git pull origin master

# check out the most appropriate branch
if [ "$(uname)" == "Darwin" ]; then
	git checkout master
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
	git checkout linux
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    echo "Cygwin not supported"
    exit 1
fi

function doIt() {
	rsync --exclude ".git/" \
		--exclude ".DS_Store" \
		--exclude ".osx" \
		--exclude ".vim" \
		--exclude "bin" \
		--exclude "init" \
		--exclude "bootstrap.sh" \
		--exclude "brew.sh" \
		--exclude "README.md" \
		--exclude "LICENSE-MIT.txt" \
		-avh --no-perms . ~;
	source ~/.bash_profile;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;
