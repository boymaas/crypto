
# echo "Creating role and database"
sudo -u postgres psql -c "create role crypto_trader with login createdb superuser password 'crypto_trader';"
sudo -u postgres psql -c "create database crypto_trader;"

echo "Create user to run app under"
function add_user_with_password() {
  pass=$(perl -e 'print crypt($ARGV[0], "password")' $2)
  useradd -m -p $pass $1 -s /bin/bash
}

add_user_with_password 'crypto' 'gekko' 

echo "Generate ssh keys"
sudo -u crypto -i <<EOS
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
EOS

# echo "Enabling crypto user ssh"
# echo 'crypto  ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers

echo "Adding githubs key to known hosts, for easy deployment"
sudo -u crypto -i <<EOS
  ssh-keyscan -H github.com >> ~/.ssh/known_hosts
EOS

echo "Adding environment file for app"
cp provision/crypto-environment ~crypto/environment
chown crypto.crypto ~crypto/environment

echo "Install rbenv for this user so deploy can go"
install_rbenv() {
  sudo -u crypto -i <<EOF
    git clone https://github.com/sstephenson/rbenv.git .rbenv
    echo 'export PATH="\$HOME/.rbenv/bin:\$PATH"' >> .profile
    echo 'eval "\$(rbenv init -)"' >> .profile

    git clone https://github.com/sstephenson/ruby-build.git .rbenv/plugins/ruby-build
EOF
}

echo "Install the local ruby version and rbenv sudo cuz we need it"
install_rbenv_ruby() {
  sudo -u crypto -i <<EOF
    rbenv install 2.0.0-p247
    rbenv system 2.0.0-p247
    rbenv local 2.0.0-p247

    git clone git://github.com/dcarley/rbenv-sudo.git ~/.rbenv/plugins/rbenv-sudo

    gem install bundler
    rbenv rehash
EOF
}


install_rbenv
install_rbenv_ruby

echo "Install libsqlite3-dev"
apt-get install -y libsqlite3-dev

echo "Install database yaml"
cp provision/database.yml ~crypto/shared/config/
chown crypto ~crypto/shared/config/database.yml

