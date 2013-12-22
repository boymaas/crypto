#!/bin/bash

cd /vagrant

# Generic provision scripts
. provision/generic/environment.sh
. provision/generic/install-talib.sh
. provision/generic/postgresql.sh
. provision/generic/user-homedir.sh
. provision/generic/user-setup.sh

# Always start with setting up environment
#environment_setup

# Install needed libs
#install libsqlite3-dev
#install libpq-dev
#install_talib

# Install database
#postgresql_install

# Provision the different user accounts
. provision/user-vagrant.sh
. provision/user-crypto-trader.sh
. provision/user-crypto.sh
