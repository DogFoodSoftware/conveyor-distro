{ stdenv } :

stdenv.mkDerivation rec {
  domain = "dogfoodsoftware.com";
  bare_name = "conveyor-install-lib";
  version = "1.0";
  name = "${bare_name}-${version}";

  src = ./lib/conveyor-install-lib.sh;

  phases = ["installPhase"];
  unpackCmd = "true";
  # This particular package is not itself a Conveyor package as such, but
  # rather a support package for Conveyor packages. Therefore, it does not
  # follow the Conveyor package conventions. It's not typically installed to
  # the environment, but rather a 'buildInput'.
  installPhase = ''
    mkdir $out;
    cp $src $out/conveyor-install-lib.sh
  '';
}
