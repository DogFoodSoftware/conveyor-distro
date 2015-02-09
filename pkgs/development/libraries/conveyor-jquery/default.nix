{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "2.1.1";
  bare-name = "conveyor-jquery";
  name = "${bare-name}-${version}";

  src = fetchurl {
    url = "http://code.jquery.com/jquery-${version}.js";
    sha256 = "1b2kprylvxwvz9rihf89axcq1jbds5wpb8pb3iph9pmfx8wg83ql";
  };  

  phases = [ "installPhase" ];

  bare_name = bare-name;

  installPhase = ''
    INSTALL_DIR=$out/conveyor/dogfoodsoftware.com/$bare_name

    mkdir -p $INSTALL_DIR
    cp -a $src $INSTALL_DIR/jquery-${version}.js
  ''; 

  meta = with stdenv.lib; {
    description = "JavaScript library designed to simplify the client-side scripting of HTML";
    homepage = http://jquery.com/;
    license = licenses.mit;
    platforms = platforms.all;
  };
}
