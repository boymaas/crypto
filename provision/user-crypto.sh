
user_setup 'crypto'

echo "Install database yaml"
cp provision/user-crypto/database.yml ~crypto/shared/config/
chown crypto ~crypto/shared/config/database.yml

