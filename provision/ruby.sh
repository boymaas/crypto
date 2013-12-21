install_ruby_system_wide () {
  bash <<EOS
    install build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev
    cd /tmp
    wget http://cache.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p247.tar.gz
    tar -xvzf ruby-2.0.0-p247.tar.gz
    cd ruby-2.0.0-p247/
    ./configure --prefix=/usr/local
    make
    make install
EOS
}

install_rbenv() {
  sudo -u vagrant -i <<EOF
    git clone https://github.com/sstephenson/rbenv.git .rbenv
    echo 'export PATH="\$HOME/.rbenv/bin:\$PATH"' >> .profile
    echo 'eval "\$(rbenv init -)"' >> .profile

    git clone https://github.com/sstephenson/ruby-build.git .rbenv/plugins/ruby-build
EOF
}

install_rbenv_ruby() {
  sudo -u vagrant -i <<EOF
    rbenv install 2.0.0-p247
    rbenv system 2.0.0-p247
    rbenv local 2.0.0-p247

    gem install bundler
    rbenv rehash
EOF

}

install_rbenv
install_rbenv_ruby
