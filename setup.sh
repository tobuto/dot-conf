#!/bin/sh

# Install zsh and change standard shell
if ! [ $(which zsh) ]; then
    if [ $(which apt-get) ]; then
        sudo apt-get install zsh
        elif [ $(which brew) ]; then
            brew install zsh
	    elif [ $(which yum) ]; then
    	    sudo yum install zsh
	    elif [ $(which zypper) ]; then
	        sudo zypper install zsh
        else
	        echo "No known package manager installed"
		    exit 
    fi
else
    echo "ZSH already installed"
fi

if ! $(echo $SHELL | grep -q "zsh"); then
    chsh -s $(which zsh)
fi
echo "\$SHELL -> zsh"

# Install Oh My Zsh
if ! [ -d ~/.oh-my-zsh ]; then
    git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
    cp ~/.zshrc ~/.zshrc.orig 2> /dev/null
fi

if ! [ $(which curl) ]; then
    if [ $(which apt-get) ]; then
        sudo apt-get install curl
        elif [ $(which brew) ]; then
            brew install curl
	    elif [ $(which yum) ]; then
    	    sudo yum install curl
	    elif [ $(which zypper) ]; then
	        sudo zypper install curl
        else
	        echo "No known package manager installed"
		    exit 
    fi
fi  

# Download xxf theme
if ! [ -f ~/.oh-my-zsh/themes/xxf.zsh-theme ]; then
    curl -Lo ~/.oh-my-zsh/themes/xxf.zsh-theme https://gist.githubusercontent.com/xfanwu/18fd7c24360c68bab884/raw/f09340ac2b0ca790b6059695de0873da8ca0c5e5/xxf.zsh-theme > /dev/null
fi

# Copy .zshrc
cp .zshrc ~/.zshrc

# Insert conf files into zshrc
if [ -e $PWD/.aliases ]; then
	echo "source $PWD/.aliases" >> ~/.zshrc
    echo "Added .aliases as source in zshrc"
fi
if [ -e $PWD/.user-conf ]; then
	echo "source $PWD/.user-conf" >> ~/.zshrc
    echo "Added .user-conf as source in zshrc"
fi

# Insert already exisiting conf files into zsh
for f in $(ls -a ~ | grep \.\*aliases\.\*); do 
	echo "source ~/$f" >> ~/.zshrc
    echo "Added $f as source in zshrc"
done

# insert Profile path in zprofile
echo "PATH=$(echo $PATH)" >> /etc/zsh/zprofile
echo "export PATH" >> /etc/zsh/zprofile
