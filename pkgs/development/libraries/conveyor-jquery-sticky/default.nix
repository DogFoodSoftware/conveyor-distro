{ stdenv, fetchurl, perl, conveyor-core, conveyor-install-lib }:

stdenv.mkDerivation rec {
  domain = "dogfoodsoftware.com";
  version = "1.0.1";
  bare_name = "conveyor-jquery-sticky";
  name = "${bare_name}-${version}";

  git-version = "5158fec61b0b144f388b055576323b575bcec8d0";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/garand/sticky/${git-version}/jquery.sticky.js";
    sha256 = "1v8bq2qfvs6dwm416506mrl2sv0vfy15zkhm5nz826zvwq3a19nl";
  };  

  phases = [ "installPhase" ];

  home = builtins.getEnv "HOME";
  install_lib = conveyor-install-lib + /conveyor-install-lib.sh;
  buildInputs = [ perl ];

  installPhase = ''
    source $install_lib

    standard_conveyor_install
  ''; 

  meta = with stdenv.lib; {
    description = "JQuery plugin to stick elements to the top while scrolling.";
    homepage = http://stickyjs.com/;
    # license = licenses.mit; ... I think
    platforms = platforms.all;
  };
}
