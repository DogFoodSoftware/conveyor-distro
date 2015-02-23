{ stdenv, procps, gnugrep, gawk, fetchFromGitHub, jre, conveyor-install-lib }:

stdenv.mkDerivation rec {
  domain = "dogfoodsoftware.com";
  bare_name = "conveyor-core";
  version = "0.1.10pre";
  name = "${bare_name}-${version}";

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

  install_lib = conveyor-install-lib + /conveyor-install-lib.sh;
  builder = ./builder.sh;

  # The 'orientdb' script needs 'ps', 'grep', 'awk', and 'java'.
  buildInputs = [ conveyor-install-lib ];
  # buildInputs = [ conveyor-install-lib conveyor-orientdb procps gnugrep gawk jre ];

  # meta = {
  #   description = "Something...";
  #   homepage = http://dogfoodsoftware.com/projects/conveyor-core/;
  # };
}
