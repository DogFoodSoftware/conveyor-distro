{ stdenv, fetchFromGitHub, conveyor-install-lib, conveyor-core }:

stdenv.mkDerivation rec {
  domain = "dogfoodsoftware.com";
  version = "1.0pre";
  bare_name = "conveyor-standards";
  name = "${bare_name}-${version}";

  home = builtins.getEnv "HOME";

  test_path = builtins.toPath home + "/playground/${domain}/${bare_name}";
  src = if builtins.pathExists test_path
    then test_path
    else fetchFromGitHub {
      owner = "DogFoodSoftware";
      repo = "${bare_name}";
      rev =  "0c2ba3314f0710eccad3e7bc51c191d1833239fb";
      sha256 = "12wchxjqzr6fdr3m56s4vq8p4f4s9spdqglg1wfr78rvymjzpfwb";
    };

  phases = [ "installPhase" ];

  install_lib = conveyor-install-lib + /conveyor-install-lib.sh;
  installPhase = ''
    source $install_lib
    standard_conveyor_install
    link_docs "$INSTALL_DIR/documentation" "${home}/.conveyor/data/dogfoodsoftware.com/conveyor-core/documentation"
  '';
}
