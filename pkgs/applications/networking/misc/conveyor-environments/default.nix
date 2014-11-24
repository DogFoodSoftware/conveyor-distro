{ stdenv, fetchzip }:

stdenv.mkDerivation rec {

  name = "conveyor-environments-master";

  src = fetchzip {
    # Critical to leave trailing '/' off. Otherwise dies with
    # not-so-useful error messages.
    url = "http://github.com/DogFoodSoftware/conveyor-environments/tarball/master";
    name = "DogFoodSoftware-conveyor-environments-e5b99a8.tar.gz";
    sha256 = "042sjqcf9bm1jw8kvqy4hb4kz8p4fryqhkq0gqfzlfz2h49f5qim";
  };  

  phases = [ "installPhase" ];

  installPhase = ''
    echo "out: $out"
    echo "src: $src"
    mkdir -p $out
    cp -a $src/* $out/
    # mkdir -p $out/css $out/js
    # closure-compiler --js $src/js/*.js > $out/js/bootstrap.js
    # lessc $src/less/bootstrap.less -O2 -x > $out/css/bootstrap.css
  ''; 

  meta = {
    description = "Environments resource spec and API.";
    homepage = http://dogfoodsoftware.com/projects/conveyor/environments;
    # license = stdenv.lib.licenses.asl20;
    # platforms = stdenv.lib.platforms.linux;
  };
}