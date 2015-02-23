{ stdenv, fetchFromGitHub, conveyor-core, conveyor-install-lib }: #, lessc, closurecompiler }:

stdenv.mkDerivation rec {
  domain = "dogfoodsoftware.com";
  bare_name = "conveyor-twitter-bootstrap";
  version = "3.3.1";
  name = "${bare_name}-${version}";

  src = fetchFromGitHub {
    owner = "twitter";
    repo = "bootstrap";
    rev =  "v${version}";
    sha256 = "13m4yvksnr776dzlzwbgkz2959r28knpff96n5i07nk97ms83f8v";
  };  

  # buildInputs = [ lessc closurecompiler ];

  phases = [ "installPhase" ];

  install_lib = conveyor-install-lib + /conveyor-install-lib.sh;

  installPhase = ''
    source $install_lib

    conveyor_standard_lib
  ''; 

  meta = {
    description = "Front-end framework for faster and easier web development";
    homepage = http://getbootstrap.com/;
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.linux;
  };
}
