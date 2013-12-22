user_create_and_setup 'crypto'

user_install_github_keys 'crypto'
user_install_authorized_key 'crypto' 'macbook-pro.pub'

user_sudo_nopasswd 'crypto'

# echo "Install database yaml"
cp provision/user-crypto/database.yml ~crypto/shared/config/
chown crypto ~crypto/shared/config/database.yml

# echo "Adding environment file for app"
cp provision/user-crypto/environment ~crypto/environment
chown crypto.crypto ~crypto/environment
