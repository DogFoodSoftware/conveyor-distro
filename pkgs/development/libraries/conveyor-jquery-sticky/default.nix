{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "1.0.1";
  bare-name = "conveyor-jquery-sticky";
  name = "${bare-name}-${version}";

  git-version = "5158fec61b0b144f388b055576323b575bcec8d0";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/garand/sticky/${git-version}/jquery.sticky.js";
    sha256 = "1v8bq2qfvs6dwm416506mrl2sv0vfy15zkhm5nz826zvwq3a19nl";
  };  

  phases = [ "installPhase" ];

  bare_name = bare-name;

  installPhase = ''
    INSTALL_DIR=$out/conveyor/dogfoodsoftware.com/$bare_name

    mkdir -p $INSTALL_DIR
    cp -a $src $INSTALL_DIR/jquery.sticky.js
  ''; 

  meta = with stdenv.lib; {
    description = "JQuery plugin to stick elements to the top while scrolling.";
    homepage = http://stickyjs.com/;
    # license = licenses.mit; ... I think
    platforms = platforms.all;
  };
}
