{ stdenv, procps, gnugrep, gawk, fetchFromGitHub, jre }:

stdenv.mkDerivation rec {
  domain-name = "dogfoodsoftware.com";
  bare-name = "conveyor-core";
  version = "0.1.3-PRE";
  name = "${bare-name}-${version}";

  home = builtins.getEnv "HOME";
  
  test_path = builtins.toPath home + "/playground/${domain-name}/${bare-name}";
  src = if builtins.pathExists test_path
    then test_path
    else fetchFromGitHub {
      owner = "DogFoodSoftware";
      repo = "${bare-name}";
      rev =  "ba51000369c694e8d49cf050b591d20a690d17e0";
      sha256 = "0al01kzq6i564br05dzswxcrwj4phdzjrjrqsd8mp7a9a1ggj8hg";
    };

  domain_name = domain-name;
  bare_name = bare-name;
  builder = ./builder.sh;

  # The 'orientdb' script needs 'ps', 'grep', 'awk', and 'java'.
  # buildInputs = [ conveyor-orientdb procps gnugrep gawk jre ];

  # meta = {
  #   description = "Something...";
  #   homepage = http://dogfoodsoftware.com/projects/conveyor-core/;
  # };
}
