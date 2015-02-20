{ stdenv, procps, gnugrep, gawk, fetchFromGitHub, jre }:

stdenv.mkDerivation rec {
  domain-name = "dogfoodsoftware.com";
  bare-name = "conveyor-core";
  version = "0.1.9-PRE";
  name = "${bare-name}-${version}";

  home = builtins.getEnv "HOME";
  
  test_path = builtins.toPath home + "/playground/${domain-name}/${bare-name}";
  src = if builtins.pathExists test_path
    then test_path
    else fetchFromGitHub {
      owner = "DogFoodSoftware";
      repo = "${bare-name}";
      rev =  "ea439f3a864c4196ea67fc3d4fc4c7563b089225";
      sha256 = "114kbq93b9nd3yk54x16wjd3a1ypsd76bc6zl878mwdlhp3bl5yi";
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
