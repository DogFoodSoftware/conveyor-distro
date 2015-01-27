{ stdenv, fetchFromGitHub }: #, lessc, closurecompiler }:

stdenv.mkDerivation rec {
  version = "3.3.1";
  name = "conveyor-twitter-bootstrap-${version}";

  src = fetchFromGitHub {
    owner = "twitter";
    repo = "bootstrap";
    rev =  "v${version}";
    sha256 = "13m4yvksnr776dzlzwbgkz2959r28knpff96n5i07nk97ms83f8v";
  };  

  # buildInputs = [ lessc closurecompiler ];

  phases = [ "installPhase" ];

  installPhase = ''
    INSTALL_DIR=$out/conveyor-twitter-bootstrap

    mkdir -p $INSTALL_DIR
    cp -a $src/* $INSTALL_DIR

    # mkdir -p $out/css $out/js
    # closure-compiler --js $src/js/*.js > $out/js/bootstrap.js
    # lessc $src/less/bootstrap.less -O2 -x > $out/css/bootstrap.css
  ''; 

  meta = {
    description = "Front-end framework for faster and easier web development";
    homepage = http://getbootstrap.com/;
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.linux;
  };
}