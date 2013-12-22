ARCHFLAGS="-arch i386" 

function install_talib() {
  
(
  cd vendor/
  tar xzf ta-lib.tgz
  cd ta-lib
  ./configure
  make
  make install
)

  sudo -u vagrant -i <<EOF
    gem install talib_ruby -- \
      --with-talib-include=/usr/local/include/ta-lib/ \
      --with-talib-lib=/usr/local/lib
EOF
}

install_talib

