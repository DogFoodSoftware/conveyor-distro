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

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/conveyor-minify
    echo "src: $src"
    echo "out: $out"
    cp -a $src/* $out/conveyor-minify
    mkdir -p /home/user/.conveyor/runtime/dogfoodsoftware.com/conveyor/distro/pkgs/development/web/conveyor-minify
    rm -f /home/user/.conveyor/runtime/dogfoodsoftware.com/conveyor/distro/pkgs/development/web/conveyor-minify/runnable
    ln -s $out/conveyor-minify /home/user/.conveyor/runtime/dogfoodsoftware.com/conveyor/distro/pkgs/development/web/conveyor-minify/runnable
    mkdir -p /home/user/.conveyor/runtime/dogfoodsoftware.com/conveyor/distro/pkgs/development/web/conveyor-minify/conf
    cp $minify_conf /home/user/.conveyor/runtime/dogfoodsoftware.com/conveyor/distro/pkgs/development/web/conveyor-minify/conf/conveyor-minify.httpd.conf
  ''; 

  meta = {
    description = "PHP service for dynamically minified CSS and JS";
    homepage = https://code.google.com/p/minify/;
  };
}