#!/usr/bin/env bash

set -e

if [ "$EUID" != "0" ]; then
  echo -e '\e[31mScript must run with root privileges!\e[0m'
  exit 1
fi

if [ "$UID" = "0" ]; then
  echo -e '\e[33mWarning: script is run as root user!\e[0m'
  seconds_to_wait="5"
  echo -e "\e[33mWaiting ${seconds_to_wait} seconds if you want to cancel...\e[0m"
  sleep ${seconds_to_wait}
fi

sudo apt-get update \
  && sudo apt-get -y install 'curl' 'git' 'zsh' \
                             'zsh-syntax-highlighting' 'fonts-powerline' \
                             'ruby-albino' 'powerline' 'fonts-powerline' \
                             'psutils'


if [ -e "${HOME}/.zshrc" ]; then
  backup_zshrc_name='.zshrc.orig.bak'
  echo "Backing up original .zshrc: ${HOME}/.zshrc => ${HOME}/${backup_zshrc_name}"
  mv ${HOME}/.zshrc ${HOME}/${backup_zshrc_name}
fi

sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
rm ${HOME}/.zshrc.pre-oh-my-zsh

ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom"

git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions $ZSH_CUSTOM/plugins/zsh-completions

echo "Rendering .zshrc file to ${HOME}/.zshrc"
sed -e "1s/[$][{]DEFAULT_USER[}]/$(whoami)/" zshrc.template > "${HOME}/.zshrc"

if [ -e "${HOME}/.config/powerline/themes/shell/default.json" ]; then
  echo "Backing up original powerline config: ${HOME}/.config/powerline/themes/shell/default.json => ${HOME}/.config/powerline/themes/shell/default.json.bak"
  mv "${HOME}/.config/powerline/themes/shell/default.json" "${HOME}/.config/powerline/themes/shell/default.json.bak"
fi

cp "default.json" "${HOME}/.config/powerline/themes/shell/default.json"
