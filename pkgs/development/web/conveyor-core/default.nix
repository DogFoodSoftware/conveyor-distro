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
      rev =  "ea439f3a864c4196ea67fc3d4fc4c7563b089225";
      sha256 = "114kbq93b9nd3yk54x16wjd3a1ypsd76bc6zl878mwdlhp3bl5yi";
    };

  install_lib = conveyor-install-lib + /conveyor-install-lib.sh;
  builder = ./builder.sh

  # The 'orientdb' script needs 'ps', 'grep', 'awk', and 'java'.
  buildInputs = [ conveyor-install-lib ];
  # buildInputs = [ conveyor-install-lib conveyor-orientdb procps gnugrep gawk jre ];

  # meta = {
  #   description = "Something...";
  #   homepage = http://dogfoodsoftware.com/projects/conveyor-core/;
  # };
}
