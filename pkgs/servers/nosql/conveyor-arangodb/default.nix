{ stdenv, fetchurl, readline, openssl, go, conveyor-install-lib }:

stdenv.mkDerivation rec {
  domain = "dogfoodsoftware.com";
  arango_version = "2.4.4";
  wrapper_version = "1";
  version = "${arango_version}-${wrapper_version}";
  bare_name = "conveyor-arango";
  name = "${bare_name}-${version}";

  home = builtins.getEnv "HOME";

  src = fetchurl {
    url = "https://www.arangodb.com/repositories/Source/ArangoDB-2.4.4.tar.bz2";
    md5 = "0e5d6ec3717f43be0dc708f8517bed5f";
  };

  phases = [ "installPhase" ];
  buildInputs = [ readline openssl go ];

  install_lib = conveyor-install-lib + /conveyor-install-lib.sh;

  installPhase = ''
    source $stdenv/setup 1
    source $install_lib

    set_install_dir
    mkdir -p $INSTALL_DIR

    tar xjf $src
    cd ArangoDB-*

    ./configure --prefix=$INSTALL_DIR --enable-relative
    make
    make install
  '';
}
