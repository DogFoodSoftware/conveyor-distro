{ stdenv, fetchurl, conveyor-install-lib } :

stdenv.mkDerivation rec {
  domain = "dogfoodsoftware.com";
  bare_name = "conveyor-phpunit";
  version = "4.5";
  name = "${bare_name}-${version}";

  src = fetchurl {
    url = "https://phar.phpunit.de/phpunit-4.5.0.phar";
    sha1 = "314423c2dfd2f09bebf04886bc1e34e12c80d409";
  };  

  phases = [ "installPhase" ];

  install_lib = conveyor-install-lib + /conveyor-install-lib.sh;
  home = builtins.getEnv "HOME";

  installPhase = ''
    source $install_lib

    set_install_dir
    mkdir -p $INSTALL_DIR
    cp $src $INSTALL_DIR/phpunit
    chmod a+x $INSTALL_DIR/phpunit
    mkdir $out/bin
    ln -s $INSTALL_DIR/phpunit $out/bin
  ''; 

  meta = {
    description = "Conveyor wrapped PHPUnit.";
    homepage = http://phpunit.de;
  };
}
