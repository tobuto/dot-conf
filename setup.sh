#!/bin/sh

# Install zsh and change standard shell
if [ $(which apt-get) ]; then
        sudo apt-get install zsh
    elif [ $(which brew) ]; then
        brew install zsh
	elif [ $(which yum) ]; then
		sudo yum install zsh
        else
	        echo "No known package manager installed"
		exit 
fi

chsh -s $(which zsh)

# Install Oh My Zsh
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp ~/.zshrc ~/.zshrc.orig

# Download xxf theme
curl -Lo ~/.oh-my-zsh/themes/xxf.zsh-theme https://gist.githubusercontent.com/xfanwu/18fd7c24360c68bab884/raw/f09340ac2b0ca790b6059695de0873da8ca0c5e5/xxf.zsh-theme

# Copy .zshrc
cp .zshrc ~/.zshrc

# Insert conf files into zshrc
if [ -e $PWD/.aliases ]; then
	echo "source $PWD/.aliases" >> ~/.zshrc
fi
if [ -e $PWD/.user-conf ]; then
	echo "source $PWD/.user-conf" >> ~/.zshrc
fi

# Insert already exisiting conf files into zsh
for f in ~/.*aliases*; do 
	echo "source $f" >> ~/.zshrc
done
