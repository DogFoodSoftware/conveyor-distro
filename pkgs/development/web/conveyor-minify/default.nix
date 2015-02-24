{ stdenv, fetchFromGitHub, conveyor-core, conveyor-install-lib }:

stdenv.mkDerivation rec {
  domain = "dogfoodsoftware.com";
  bare_name = "conveyor-minify";
  version = "2.1.7.4";
  name = "${bare_name}-${version}";

  src = fetchFromGitHub {
    owner = "mrclay";
    repo = "minify";
    rev =  "db7fe244932ea77cf1438965693672ea12b33da8";
    sha256 = "1a1567vpbjb8q71pxsr4kpnw1qvi9p7i61pky8mp4m27z4hh6h4r";
  };

  minify_conf = ./conf/minify.httpd.conf;
  minify_src = ./src;
  home = builtins.getEnv "HOME";

  phases = [ "installPhase" ];

  install_lib = conveyor-install-lib + /conveyor-install-lib.sh;

  installPhase = ''
    source $install_lib

    conveyor_standard_install
    
    for i in `ls $minify_src`; do
      chmod u+w $INSTALL_DIR/min/$i
      cp $minify_src/$i $INSTALL_DIR/min
      chmod u-w $INSTALL_DIR/min/$i
    done
    
    echo "Creatng / updating configuration..."
    mkdir -p $INSTALL_DIR/conf
    cp $minify_conf $INSTALL_DIR/conf/minify.httpd.conf

    rm -f $home/.conveyor/data/dogfoodsoftware.com/conveyor-apache/conf-inc/minify.httpd.conf
    ln -s $INSTALL_DIR/conf/minify.httpd.conf $home/.conveyor/data/dogfoodsoftware.com/conveyor-apache/conf-inc/

    mkdir -p $home/.conveyor/data/dogfoodsoftware.com/conveyor-minify/cache;
  '';

  meta = {
    description = "PHP service for dynamically minified CSS and JS";
    homepage = https://code.google.com/p/minify/;
  };
}
