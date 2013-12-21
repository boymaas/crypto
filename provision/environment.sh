install() {
  apt-get install -y -qq $*
}
export -f install

apt-get update
install vim htop whois git make
install python-software-properties

# build requirements for bitcoind
install_build_essentials() {
  install build-essential \
          libtool autotools-dev autoconf \
          libssl-dev \
          libboost-all-dev \
          pkg-config 
}
export -f install_build_essentials
