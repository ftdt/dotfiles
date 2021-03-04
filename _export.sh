#!/bin/bash
backup_file() {
    mv $1 $1.bak
}

backup_folder() {
    rm -rf $1.bak
    if [ -f $1 ]; then
        mv $1 $1.bak
    fi
}

symlink() {
    ln -s $(pwd)/$1 $HOME/$2
}

# backup
backup_file $HOME/.zshrc
backup_file $HOME/.gitconfig
backup_file $HOME/.gitignore_global
backup_file $HOME/.git-credentials
backup_file $HOME/.config/alacritty/alacritty.yml
backup_file $HOME/.tmux.conf
backup_file $HOME/.Xresources

backup_folder $HOME/.utils
backup_folder $HOME/.keys
backup_folder $HOME/.ssh
backup_folder $HOME/.config/nvim
backup_folder $HOME/.config/coc
backup_folder $HOME/.xmonad

# create symbolic links
symlink zshrc                .zshrc
symlink git/gitconfig        .gitconfig
symlink git/gitignore_global .gitignore_global
symlink git/git-credentials  .git-credentials
symlink tmux/tmux.conf       .tmux.conf
symlink xmonad/Xresources    .Xresources

symlink utils        .utils
symlink secrets/ssh  .ssh
symlink secrets/keys .keys
symlink nvim         .config/
symlink nvim/coc     .config/
symlink xmonad       .xmonad

# handle linux related dotfiles
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    symlink alacritty/alacritty.linux.yml .config/alacritty/alacritty.yml

    backup_folder $HOME/.config/i3
    mkdir $HOME/.config/i3
    symlink i3/i3_config .config/i3/config
    symlink i3/i3_start_up.sh crons/post/i3_start_up.sh

    backup_folder $HOME/.config/i3status
    mkdir $HOME/.config/i3status
    symlink i3/i3status_config .config/i3status/config

    sudo cp xorg.conf /etc/X11/xorg.conf
# handle OSX related dotfiles
elif [[ "$OSTYPE" == "darwin" ]]; then
    symlink alacritty/alacritty.yml .config/alacritty/alacritty.yml
fi

gpg --export-secret-key -a $GPG_UID > secrets/gpg/gpg.key
