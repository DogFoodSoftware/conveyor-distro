{ stdenv, nodejs, conveyor-core, conveyor-install-lib }:

stdenv.mkDerivation rec {
  domain = "dogfoodsoftware.com";
  bare_name = "conveyor-less";
  version = "0.1pre";
  name = "${bare_name}-${version}";

  buildInputs = [ nodejs ];

  phases = [ "installPhase" ];

  home = builtins.getEnv "HOME";

  install_lib = conveyor-install-lib + /conveyor-install-lib.sh;

  installPhase = ''
    source $install_lib

    conveyor_standard_install
    # Need to define 'HOME' so npm can find the '.npm' dir, which
    # defines the packages, like 'less'.
    export HOME="$home"
    npm install less

    mkdir $out/bin
    ln -s $INSTALL_DIR/node_modules/less/bin/lessc $out/bin/lessc
  ''; 

  meta = {
    description = "Conveyor installation of LESS.";
    homepage = http://lesscss.org;
  };
}
