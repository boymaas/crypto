install_homedir() {
  sudo -u vagrant -i <<EOF
    # install home dir
    git clone https://github.com/boymaas/dotfiles.git
    mv dotfiles/.git .
    rm -r dotfiles
    git checkout master .
EOF
}

install_vimconfig() {
  # we need a vim with ruby support build in to compile against
  # command-T
  install vim-nox

  sudo -u vagrant -i <<EOF
    if [ ! -L .vimrc ]; then
      # install vim config files
      git clone https://github.com/boymaas/vimfiles.git 
      mv vimfiles .vim 
      ln -s .vim/vimrc .vimrc

      cd .vim
      git submodule init
      git submodule update
    fi
EOF

  echo Perform bundle install and build command-t 
  echo USE SYSTEM RUBY TO BUILD COMMAND-T

  echo vim +BundleInstall +qall 

  echo

  echo    cd .vim/bundle/Command-t/ruby/command-t/ 
  echo    rbenv local system
  echo    ruby extconf.rb make
  echo    make
  echo    rbenv local 2.0.0-p247

}

install_tmux() {
  install cmake

  sudo -u vagrant -i <<EOF
    git clone https://github.com/tony/tmux-config.git ~/.tmux-tony
    ln -s ~/.tmux-tony/.tmux.conf ~/.tmux.conf
    cd ~/.tmux-tony
    git submodule init
    git submodule update
    cd ~/.tmux-tony/vendor/tmux-mem-cpu-load
    cmake .
    make
    sudo make install
    cd ~
EOF

}


install_homedir
install_vimconfig
install_tmux
