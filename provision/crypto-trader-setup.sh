
# echo "Creating role and database"
sudo -u postgres psql -c "create role crypto_trader with superuser password 'crypto_trader';"
sudo -u postgres psql -c "create database crypto_trader;"

echo "Create user to run app under"
function add_user_with_password() {
  pass=$(perl -e 'print crypt($ARGV[0], "password")' $2)
  useradd -m -p $pass $1 -s /bin/bash
}

add_user_with_password 'crypto' 'gekko' 

echo "Generate ssh keys"
sudo -u crypto -i <<EOS
ssh-keygen -t rsa -N "geed is good" -f ~/.ssh/id_rsa
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

