{ stdenv, fetchzip }:

stdenv.mkDerivation rec {

  name = "conveyor-environments-master";

  src = fetchzip {
    # Critical to leave trailing '/' off. Otherwise dies with
    # not-so-useful error messages.
    url = "http://github.com/DogFoodSoftware/conveyor-environments/tarball/master";
    name = "DogFoodSoftware-conveyor-environments-e5b99a8.tar.gz";
    sha256 = "1gs6g02swf0iakf61bp45vn7iq7014k06xf56wy5r69hqwcxzcid";
  };

  home = builtins.getEnv "HOME";

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out
    cp -a $src/* $out/
    mkdir -p "$home/.conveyor/runtime/dogfoodsoftware.com/conveyor/environments"
    rm -f "$home/.conveyor/runtime/dogfoodsoftware.com/conveyor/environments/runnable"
    rm -f "$home/.conveyor/runtime/dogfoodsoftware.com/conveyor/environments/conf"
    ln -s "$out/src" "$home/.conveyor/runtime/dogfoodsoftware.com/conveyor/environments/runnable"
    ln -s "$out/conf" "$home/.conveyor/runtime/dogfoodsoftware.com/conveyor/environments/conf"
    rm -f /home/user/.conveyor/data/dogfoodsoftware.com/conveyor/distro/pkgs/servers/http/conveyor-apache/conf-inc/__admin-server.httpd.conf
    cp $out/conf/__admin-server.httpd.conf /home/user/.conveyor/data/dogfoodsoftware.com/conveyor/distro/pkgs/servers/http/conveyor-apache/conf-inc/
  ''; 

  meta = {
    description = "Environments resource spec and API.";
    homepage = http://dogfoodsoftware.com/projects/conveyor/environments;
    # license = stdenv.lib.licenses.asl20;
    # platforms = stdenv.lib.platforms.linux;
  };
}