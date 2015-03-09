{ stdenv, fetchFromGitHub, conveyor-install-lib }:

stdenv.mkDerivation rec {
  domain = "dogfoodsoftware.com";
  bare_name = "conveyor-workflow";

  home = builtins.getEnv "HOME";
  
  test_path = builtins.toPath home + "/playground/${domain}/${bare_name}";
  src = if builtins.pathExists test_path
    then test_path
    else fetchFromGitHub {
      owner = "DogFoodSoftware";
      repo = "${bare_name}";
      rev =  "18761dc8c66d7c2641d4e7e6c37174f5ce45103a";
      sha256 = "15r83dl2vda5didmqry8j0zrbs47wfd474668dfxayhcx58fnwhm";
    };

  distro-version = "0.1pre";
  version = if test_path == src
    then "9999"
    else "${distro-version}";
  name = "${bare_name}-${version}";

  install_lib = conveyor-install-lib + /conveyor-install-lib.sh;
  buildInputs = [ conveyor-install-lib ];

  phases = [ "installPhase" ];

  installPhase = ''
    source $install_lib

    standard_conveyor_install
  '';

  # meta = {
  #   description = "Something...";
  #   homepage = http://dogfoodsoftware.com/projects/conveyor-core/;
  # };
}
