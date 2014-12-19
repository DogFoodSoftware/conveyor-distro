{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "conveyor-minify";

  src = fetchFromGitHub {
    owner = "mrclay";
    repo = "minify";
    rev =  "db7fe244932ea77cf1438965693672ea12b33da8";
    sha256 = "1a1567vpbjb8q71pxsr4kpnw1qvi9p7i61pky8mp4m27z4hh6h4r";
  };

  minify_conf = ./conf/minify.httpd.conf;
  minify_src = ./src;

  phases = [ "installPhase" ];

  installPhase = ''
    # Always create package context to avoid name collisions.
    INSTALL_DIR=$out/conveyor-minify
    RUNTIME_LINK=/home/user/.conveyor/runtime/dogfoodsoftware.com/conveyor-minify

    mkdir -p $INSTALL_DIR
    cp -a $src/* $INSTALL_DIR
    
    for i in `ls $minify_src`; do
      chmod u+w $INSTALL_DIR/min/$i
      cp $minify_src/$i $INSTALL_DIR/min
      chmod u-w $INSTALL_DIR/min/$i
    done
    
    echo "Creating runtime link..."
    mkdir -p `basename $RUNTIME_LINK`
    rm -f $RUNTIME_LINK
    ln -s $INSTALL_DIR $RUNTIME_LINK

    echo "Creatng / updating configuration..."
    mkdir -p $INSTALL_DIR/conf
    cp $minify_conf $INSTALL_DIR/conf/minify.httpd.conf
  ''; 

  meta = {
    description = "PHP service for dynamically minified CSS and JS";
    homepage = https://code.google.com/p/minify/;
  };
}