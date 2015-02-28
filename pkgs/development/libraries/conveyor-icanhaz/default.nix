{ stdenv, fetchurl, conveyor-core, conveyor-install-lib }:

stdenv.mkDerivation rec {
  version = "0.10.13";
  bare_name = "conveyor-icanhaz";
  name = "${bare_name}-${version}";

  src = fetchurl {
    url = "https://github.com/HenrikJoreteg/ICanHaz.js/raw/master/ICanHaz.js";
    sha256 = "0l3makazf8kfzwhn7s5r4b5xjhjfpacvn833w66316nha9c8y2ny";
  };  

  phases = [ "installPhase" ];

  install_lib = conveyor-install-lib + /conveyor-install-lib.sh

  installPhase = ''
    source $install_lib

    standard_conveyor_install
  ''; 

  meta = with stdenv.lib; {
    description = "JavaScript templating library.";
    homepage = http://icanhazjs.com/;
    license = licenses.mit;
    platforms = platforms.all;
  };
}
