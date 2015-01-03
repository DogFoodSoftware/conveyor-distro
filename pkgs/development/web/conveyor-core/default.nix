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
      # Following not updated yet
      rev =  "db7fe244932ea77cf1438965693672ea12b33da8";
      sha256 = "1a1567vpbjb8q71pxsr4kpnw1qvi9p7i61pky8mp4m27z4hh6h4r";
    };

  builder = ./builder.sh;

  # The 'orientdb' script needs 'ps', 'grep', 'awk', and 'java'.
  buildInputs = [ conveyor-orientdb procps gnugrep gawk jre ];

  # meta = {
  #   description = "Something...";
  #   homepage = http://dogfoodsoftware.com/projects/conveyor-core/;
  # };
}