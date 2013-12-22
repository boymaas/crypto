#!/usr/bin/env bash

# using https://github.com/rkiel/vagrant-starter/tree/master/provision

postgresql_install() {
echo "Begin PostgreSQL"

echo "Installing Postgres 9.1"
apt-get install -y postgresql-9.1

echo "Creating role"
sudo -u postgres psql -c "create role crypto login createdb password 'crypto';"

echo "Updating template with UTF-8"
sudo -u postgres psql -c "update pg_database set datistemplate=false where datname='template1';"
sudo -u postgres psql -c "drop database Template1;"
sudo -u postgres psql -c "create database template1 with owner=postgres encoding='UTF-8' lc_collate='en_US.utf8' lc_ctype='en_US.utf8' template template0;"
sudo -u postgres psql -c "update pg_database set datistemplate=true where datname='template1';"

echo "Editing conf files to support network access"
# sed -i -e "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /etc/postgresql/9.1/main/postgresql.conf
# sed -i -e "s/127.0.0.1\/32/0.0.0.0\/0/"                               /etc/postgresql/9.1/main/pg_hba.conf

echo "Restarting"
service postgresql restart

echo "End PostgreSQL"
}


postgresql_create_database_and_role() {
  # echo "Creating role and database"
  sudo -u postgres psql -c "create role $1 with login createdb superuser password '$1';"
  sudo -u postgres psql -c "create database $1;"
  sudo -u postgres psql -c "grant all on database $1 to $1;"
}

export -f postgresql_install
