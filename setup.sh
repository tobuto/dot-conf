#!/bin/sh
INSTALL=""
# Check for root
SUDO=''
if [ `whoami` != root ]; then
    SUDO='sudo'
fi
# Install zsh and change standard shell
if [ $(which zsh) ]; then
    echo "ZSH already installed"
else
    INSTALL=$INSTALL" zsh"
fi

if [ $(which curl) ]; then
    echo "CURL already installed"
else
    INSTALL=$INSTALL" curl"
fi

# Check if chsh is installed
if [ $(which chsh) ]; then
    echo "chsh already installed"
else
    INSTALL=$INSTALL" util-linux-user"
fi

if [ ! -z $INSTALL ]; then
    if [ $(which apt-get) ]; then
        $SUDO apt-get install $INSTALL
    elif [ $(which brew) ]; then
        $SUDO install $INSTALL
    elif [ $(which yum) ]; then
        $SUDO yum install $INSTALL
    elif [ $(which zypper) ]; then
        $SUDO zypper install $INSTALL
    else
        echo "No known package manager installed"
        exit
    fi
fi

if ! $(echo $SHELL | grep -q "zsh"); then
    $SUDO chsh $(whoami) -s $(which zsh)
fi
echo "\$SHELL -> zsh"

# Install Oh My Zsh
if ! [ -d ~/.oh-my-zsh ]; then
    git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
    cp ~/.zshrc ~/.zshrc.orig 2> /dev/null
fi

# Copy xxf theme
if ! [ -f ~/.oh-my-zsh/themes/xxf.zsh-theme ]; then
    cp ./xxf.zsh-theme ~/.oh-my-zsh/themes/xxf.zsh-theme
fi

# Copy .zshrc
cp .zshrc ~/.zshrc

# Insert conf files into zshrc
if [ -e $PWD/.aliases ]; then
	echo "source $PWD/.aliases" >> ~/.zshrc
    echo "Added .aliases as source in zshrc"
fi
if [ -e $PWD/.user-conf ]; then
    prompt=y
else
    read -p "Do you want to create a User Config file? <y/N> " prompt
fi
if (echo "$prompt" | grep -Eq "^[yY](es)*$"); then
    touch $PWD/.user-conf
    echo "export DOTCONFPATH=$PWD" >> ~/.zshrc
    echo "Created .user-conf"
fi

if [ -e $PWD/.user-conf ]; then
    tmp=$(mktemp)
    awk -v pwd=$PWD '!found && /source \$ZSH\/oh-my-zsh.sh/ { print "source "pwd"/.user-conf"; found=1 } 1' ~/.zshrc > $tmp
    mv $tmp ~/.zshrc
    echo "Added .user-conf as source in zshrc"
fi

# Insert already exisiting conf files into zsh
for f in $(ls -a ~ | grep \.\*aliases\.\*); do
	echo "source ~/$f" >> ~/.zshrc
    echo "Added $f as source in zshrc"
done

# insert Profile path in zprofile
echo "PATH=$(echo $PATH)" | $SUDO tee -a /etc/zsh/zprofile
echo "export PATH" | $SUDO tee -a /etc/zsh/zprofile
