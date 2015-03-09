{ stdenv, fetchFromGitHub, conveyor-install-lib }:

stdenv.mkDerivation rec {
  domain = "dogfoodsoftware.com";
  bare_name = "conveyor-pest";
  version = "1.0";
  name = "${bare_name}-${version}";

  src = fetchFromGitHub {
    owner = "educoder";
    repo = "pest";
    rev =  "fcb539e03c03bc925b93004097a268e6fd484dd8";
    sha256 = "0g3bvzn5vwij3xfvl1mhncr86vnhj2xkkm2kaixx43b9f7jx1x0c";
  };  

  phases = [ "installPhase" ];

  install_lib = conveyor-install-lib + /conveyor-install-lib.sh;
  home = builtins.getEnv "HOME";

  installPhase = ''
    source $install_lib

    standard_conveyor_install
  ''; 

  meta = {
    description = "Conveyor wrapped Pest.";
    homepage = http://github.com/educoder/pest;
  };
}
