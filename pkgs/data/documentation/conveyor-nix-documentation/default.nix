{ stdenv, fetchFromGitHub, conveyor-core, conveyor-install-lib }:

stdenv.mkDerivation rec {
  domain = "dogfoodsoftware.com";
  bare_name = "conveyor-nix-documentation";
  version = "0.1.4pre";
  name = "${bare_name}-${version}";

  home = builtins.getEnv "HOME";

  test_path = builtins.toPath home + "/playground/dogfoodsoftware.com/${bare_name}";
  src = if builtins.pathExists test_path
    then test_path
    else fetchFromGitHub {
      owner = "DogFoodSoftware";
      # These values are bogus.
      repo = "${name}";
      rev =  "155cc95b2e3fc242f66cf23c45218bb70e0cc131";
      sha256 = "18x2rmdb64kzd8bnh3sfyyfla8yvhs8cz7d755277p01jcljlp6v";
    };

  phases = [ "installPhase" ];
  install_lib = conveyor-install-lib + /conveyor-install-lib.sh;

  installPhase = ''
    source $install_lib

    standard_conveyor_install

    link_docs "$INSTALL_DIR/documentation" "${home}/.conveyor/data/dogfoodsoftware.com/conveyor-core/documentation"
  '';
}
