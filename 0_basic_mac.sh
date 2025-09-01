#!/bin/bash

set -x	# print commands and their arguments as they are executed
set -e	# exit immediately if anything you're running returns a non-zero return code

# proxy  TODO change its contents!
# cp ./assets/proxy ~/.proxy
# cp ./assets/unproxy ~/.unproxy

# TODO  comment it if not needed!
# source ~/.proxy

# CHANGED: Install Homebrew if not present
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # CHANGED: Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

# CHANGED: Use Homebrew instead of apt for package installation
brew update
brew install vim curl wget git tmux zsh htop tree neofetch zip unzip git-lfs

# CHANGED: Install macOS-specific alternatives for Linux tools
brew install nload iftop iotop btop
# CHANGED: net-tools equivalent on macOS (built-in networking tools are sufficient)
# Note: macOS has built-in equivalents like netstat, ifconfig

echo \
'unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim
set number
set mouse=a
" ref: https://stackoverflow.com/questions/234564/tab-key-4-spaces-and-auto-indent-after-curly-braces-in-vim
filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab
syntax on' \
	> ~/.vimrc

echo -e "set -g mouse on
set -g history-limit 50000
set-option -g default-shell /bin/zsh" \
	> ~/.tmux.conf

# CHANGED: Use different approach for changing default shell on macOS
# CHANGED: Check if zsh is already the default shell before changing
current_shell=$(dscl . -read ~/ UserShell | sed 's/UserShell: //')
zsh_path=$(which zsh)
if [[ "$current_shell" != "$zsh_path" ]]; then
    # CHANGED: Add zsh to allowed shells if not present
    if ! grep -q "$zsh_path" /etc/shells; then
        echo "$zsh_path" | sudo tee -a /etc/shells
    fi
    # CHANGED: Use chsh without sudo (sudo not typically needed on macOS for own user)
    chsh -s "$zsh_path"
fi

# oh my zsh
rm -rf ~/.oh-my-zsh
yes | sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# configurations of default theme of oh my zsh
# cp ~/.oh-my-zsh/themes/robbyrussell.zsh-theme ~/.oh-my-zsh/themes/robbyrussell.zsh-theme.bak
# cp ./assets/robbyrussell.zsh-theme ~/.oh-my-zsh/themes/robbyrussell.zsh-theme

# add zsh plugins
rm -rf ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
rm -rf ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

cp ./assets/zshrc ~/.zshrc
# zsh
# source ~/.zshrc

# p10k theme
rm -rf ~/powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo -e '\nsource ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc
echo -e '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> ~/.zshrc
cp ./assets/p10k.zsh ~/.p10k.zsh

# ADDED: Reminder for macOS users
echo ""
echo "Setup complete! Please note:"
echo "1. You may need to restart your terminal or run 'source ~/.zshrc' for changes to take effect"
echo "2. If you're on Apple Silicon (M1/M2/M3), Homebrew is installed to /opt/homebrew"
echo "3. Some tools may require additional setup or have different behavior on macOS"