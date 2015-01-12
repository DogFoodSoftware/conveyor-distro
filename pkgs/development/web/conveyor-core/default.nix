{ stdenv, procps, gnugrep, gawk, fetchFromGitHub, jre, conveyor-orientdb }:

stdenv.mkDerivation rec {
  name = "conveyor-core";

  home = builtins.getEnv "HOME";
  
  test_path = builtins.toPath home + "/playground/dogfoodsoftware.com/conveyor/core";
  src = if builtins.pathExists test_path
    then test_path
    else fetchFromGitHub {
      owner = "DogFoodSoftware";
      repo = "conveyor-core";
      rev =  "155cc95b2e3fc242f66cf23c45218bb70e0cc131";
      sha256 = "18x2rmdb64kzd8bnh3sfyyfla8yvhs8cz7d755277p01jcljlp6v";
    };

  builder = ./builder.sh;

  # The 'orientdb' script needs 'ps', 'grep', 'awk', and 'java'.
  buildInputs = [ conveyor-orientdb procps gnugrep gawk jre ];

  # meta = {
  #   description = "Something...";
  #   homepage = http://dogfoodsoftware.com/projects/conveyor-core/;
  # };
}