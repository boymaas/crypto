cd /vagrant

# Setup config variables
. provision/config.sh

# Setup environment and define provisioning helpers
. provision/environment.sh

# # Install bitcoind
# . provision/bitcoind.sh

# Postgresql
. provision/postgresql.sh

# Configure our crypto user
. provision/user-vagrant.sh
. provision/user-crypto.sh
. provision/user-crypto-trader.sh
