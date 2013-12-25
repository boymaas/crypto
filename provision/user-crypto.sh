user_create_and_setup 'crypto'

user_install_github_keys 'crypto'
user_install_authorized_key 'crypto' 'macbook-pro.pub'
user_sudo_nopasswd 'crypto'

postgresql_create_database_and_role 'crypto'

# echo "Install database yaml, for use with mina"
sudo -u crypto -i <<EOS
  mkdir -p shared/config
EOS
cp provision/user-crypto/database.yml /home/crypto/shared/config/
chown crypto.crypto /home/crypto/shared/config/database.yml

# echo "Adding environment file for app"
cp provision/user-crypto/environment ~crypto/environment
chown crypto.crypto ~crypto/environment
