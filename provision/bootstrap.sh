cd /vagrant

# Setup config variables
. provision/config.sh

# Setup environment and define provisioning helpers
. provision/environment.sh

# # Install bitcoind
# . provision/bitcoind.sh

# In development mode, so we can develop inside vagrant
. provision/homedir.sh

# Rbenv ruby setup
. provision/ruby.sh

# Postgresql
. provision/postgresql.sh
