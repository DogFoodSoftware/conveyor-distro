{ stdenv, fetchFromGitHub }: #, lessc, closurecompiler }:

stdenv.mkDerivation rec {
  version = "3.3.0";
  name = "conveyor-twitter-bootstrap-${version}";

  src = fetchFromGitHub {
    owner = "twitter";
    repo = "bootstrap";
    rev =  "v${version}";
    sha256 = "1d70mhxx2pwp0hghjynz17a2s3vj6wj1mdg0sg9dgwkmlnbxv7jy";
  };  

  # buildInputs = [ lessc closurecompiler ];

  phases = [ "installPhase" ];

  installPhase = ''
    echo "out: $out"
    echo "src: $src"
    mkdir -p $out/conveyor-twitter-bootstrap
    cp -a $src/* $out/conveyor-twitter-bootstrap
    mkdir -p /home/user/.conveyor/runtime/dogfoodsoftware.com/conveyor/distro/pkgs/development/web/conveyor-twitter-bootstrap
    rm /home/user/.conveyor/runtime/dogfoodsoftware.com/conveyor/distro/pkgs/development/web/conveyor-twitter-bootstrap/runnable
    ln -s $out/conveyor-twitter-bootstrap /home/user/.conveyor/runtime/dogfoodsoftware.com/conveyor/distro/pkgs/development/web/conveyor-twitter-bootstrap/runnable



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