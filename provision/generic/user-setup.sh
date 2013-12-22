function user_create_database_and_roles() {
  # echo "Creating role and database"
  sudo -u postgres psql -c "create role $1 with login createdb superuser password '$1';"
  sudo -u postgres psql -c "create database $1;"
  sudo -u postgres psql -c "grant all on database $1 to $1;"
}

function user_create_with_password() {
  echo "Create user to run app under"
  pass=$(perl -e 'print crypt($ARGV[0], "password")' "random seed")
  useradd -m -p $pass $1 -s /bin/bash
}

add_user_with_password 'crypto' 'gekko' 

function user_generate_ssh_keys() {
  echo "Generate ssh keys"
  sudo -u $1 -i <<EOS
  ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
EOS
}

# echo "Enabling crypto user ssh"
# echo 'crypto  ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers

function user_add_github_keys() {
  echo "Adding githubs key to known hosts, for easy deployment"
  sudo -u $1 -i <<EOS
    ssh-keyscan -H github.com >> ~/.ssh/known_hosts
EOS
}

echo "Adding environment file for app"
cp provision/crypto-environment ~crypto/environment
chown crypto.crypto ~crypto/environment

echo "Install rbenv for this user so deploy can go"
function user_install_rbenv() {
  sudo -u $1 -i <<EOF
    git clone https://github.com/sstephenson/rbenv.git .rbenv
    echo 'export PATH="\$HOME/.rbenv/bin:\$PATH"' >> .profile
    echo 'eval "\$(rbenv init -)"' >> .profile

    git clone https://github.com/sstephenson/ruby-build.git .rbenv/plugins/ruby-build
EOF
}

echo "Install the local ruby version and rbenv sudo cuz we need it"
function user_install_rbenv_ruby() {
  sudo -u $1 -i <<EOF
    rbenv install 2.0.0-p247
    rbenv system 2.0.0-p247
    rbenv local 2.0.0-p247

    git clone git://github.com/dcarley/rbenv-sudo.git ~/.rbenv/plugins/rbenv-sudo

    gem install bundler
    rbenv rehash
EOF
}

function user_setup() {
  user_create_database_and_roles $1
  user_create_with_password $1
  user_generate_ssh_keys $1
  user_add_github_keys $1
  user_install_rbenv $1
  user_install_rbenv_ruby $1
}

export -f user_setup

