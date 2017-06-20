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

if [ ! -z $INSTALL ]; then
    if [ $(which apt-get) ]; then
    exit
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
    chsh -s $(which zsh)
fi
echo "\$SHELL -> zsh"

# Install Oh My Zsh
if ! [ -d ~/.oh-my-zsh ]; then
    git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
    cp ~/.zshrc ~/.zshrc.orig 2> /dev/null
fi

# Install jump plugin with following symbolic links
while true; do
    read -p "Do you want the jump plugin which follows symbolic links? [yes]: " yn
        case $yn in
            [Yy][Ee][Ss]|[Yy]|"" )
                echo "Downloading new jump plugin..."
                curl -Lo ~/.oh-my-zsh/plugins/jump/jump.plugin.zsh https://raw.githubusercontent.com/kingmarv/oh-my-zsh/master/plugins/jump/jump.plugin.zsh > /dev/null
                echo "New jump plugin enabled"
                break;;
            [Nn][Oo]|[Nn] )
                echo "Skipping new jump plugin"
                break;;
            * )
                echo "Please answer yes or no.";;
    esac
done

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
