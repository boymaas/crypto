user_create_and_setup 'crypto_trader'

user_install_github_keys 'crypto_trader'

cp provision/user-crypto-trader/environment ~crypto_trader/environment
chown crypto_trader.crypto_trader ~crypto/environment

