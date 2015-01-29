{ stdenv, procps, gnugrep, gawk, fetchFromGitHub, jre, conveyor-orientdb }:

stdenv.mkDerivation rec {
  domain-name = "dogfoodsoftware.com";
  bare-name = "conveyor-core";
  version = "0.1.1-PRE";
  name = "${bare-name}-${version}";

  home = builtins.getEnv "HOME";
  
  test_path = builtins.toPath home + "/playground/${domain-name}/${bare-name}";
  src = if builtins.pathExists test_path
    then test_path
    else fetchFromGitHub {
      owner = "DogFoodSoftware";
      repo = "${bare-name}";
      rev =  "5e0e3d261d98ebf4e2af1b815eea9cfb0122a22d";
      sha256 = "0zycbra3490w91plxhlkfp910if7krn36ncm7ccqx6lqh4yn41w2";
    };

  domain_name = domain-name;
  bare_name = bare-name;
  builder = ./builder.sh;

  # The 'orientdb' script needs 'ps', 'grep', 'awk', and 'java'.
  buildInputs = [ conveyor-orientdb procps gnugrep gawk jre ];

  # meta = {
  #   description = "Something...";
  #   homepage = http://dogfoodsoftware.com/projects/conveyor-core/;
  # };
}