{ stdenv, procps, gnugrep, gawk, fetchFromGitHub, jre, conveyor-orientdb }:

stdenv.mkDerivation rec {
  domain-name = "dogfoodsoftware.com";
  bare-name = "conveyor-core";
  version = "0.1-PRE";
  name = "${bare-name}-${version}";

  home = builtins.getEnv "HOME";
  
  test_path = builtins.toPath home + "/playground/${domain-name}/${bare-name}";
  src = if builtins.pathExists test_path
    then test_path
    else fetchFromGitHub {
      owner = "DogFoodSoftware";
      repo = "${bare-name}";
      rev =  "155cc95b2e3fc242f66cf23c45218bb70e0cc131";
      sha256 = "18x2rmdb64kzd8bnh3sfyyfla8yvhs8cz7d755277p01jcljlp6v";
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