user_create_and_setup 'crypto_trader'

user_install_github_keys 'crypto_trader'
user_install_authorized_key 'crypto_trader' 'macbook-pro.pub'
user_sudo_nopasswd 'crypto_trader'

postgresql_create_database_and_role 'crypto_trader'

cp provision/user-crypto-trader/environment ~crypto_trader/environment
chown crypto_trader.crypto_trader ~crypto_trader/environment

