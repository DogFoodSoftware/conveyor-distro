{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "0.10.13";
  bare-name = "conveyor-icanhaz";
  name = "${bare-name}-${version}";

  src = fetchurl {
    url = "https://github.com/HenrikJoreteg/ICanHaz.js/raw/master/ICanHaz.js";
    sha256 = "0l3makazf8kfzwhn7s5r4b5xjhjfpacvn833w66316nha9c8y2ny";
  };  

  phases = [ "installPhase" ];

  bare_name = bare-name;

  installPhase = ''
    INSTALL_DIR=$out/conveyor/dogfoodsoftware.com/$bare_name

    mkdir -p $INSTALL_DIR
    cp -a $src $INSTALL_DIR/ICanHaz.js
  ''; 

  meta = with stdenv.lib; {
    description = "JavaScript templating library.";
    homepage = http://icanhazjs.com/;
    license = licenses.mit;
    platforms = platforms.all;
  };
}
