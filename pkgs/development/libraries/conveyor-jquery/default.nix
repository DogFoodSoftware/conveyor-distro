{ stdenv, fetchurl, perl, conveyor-core, conveyor-install-lib }:

stdenv.mkDerivation rec {
  domain = "dogfoodsoftware.com";
  version = "2.1.1";
  bare_name = "conveyor-jquery";
  name = "${bare_name}-${version}";

  src = fetchurl {
    url = "http://code.jquery.com/jquery-${version}.js";
    sha256 = "1b2kprylvxwvz9rihf89axcq1jbds5wpb8pb3iph9pmfx8wg83ql";
  };  

  phases = [ "installPhase" ];

  install_lib = conveyor-install-lib + /conveyor-install-lib.sh;
  home = builtins.getEnv "HOME";
  buildInputs = [ perl ];

  installPhase = ''
    source $install_lib

    standard_conveyor_install
  ''; 

  meta = with stdenv.lib; {
    description = "JavaScript library designed to simplify the client-side scripting of HTML";
    homepage = http://jquery.com/;
    license = licenses.mit;
    platforms = platforms.all;
  };
}
