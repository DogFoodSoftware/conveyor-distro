{ stdenv, fetchurl, conveyor-core, conveyor-install-lib }:

stdenv.mkDerivation rec {
  domain = "dogfoodsoftware.com";
  bare_name = "conveyor-composer";
  version = "1.0.0-pre9";
  name = "${bare_name}-${version}";

  src = fetchurl {
    url = "https://getcomposer.org/download/1.0.0-alpha9/composer.phar";
    name = "composer.phar";
    md5 = "05df355b5277c8c9012470e699fa5494";
  };

  phases = [ "installPhase" ];

  home = builtins.getEnv "HOME";

  install_lib = conveyor-install-lib + /conveyor-install-lib.sh;

  installPhase = ''
    source $install_lib

    mkdir -p $INSTALL_DIR
    cp -a $src $INSTALL_DIR/composer.phar

    make_runtime_link
  ''; 

  meta = {
    description = "Conveyor packaged Composer dependency management for PHP.";
    homepage = http://getcomposer.org/;
  };
}
