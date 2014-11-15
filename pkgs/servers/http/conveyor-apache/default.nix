{ stdenv, fetchurl, perl, pkgconfig, gcc, openssl, zlib }:

stdenv.mkDerivation {
  inherit perl;

  name = "conveyor-apache-2.2.26";

  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://archive.apache.org/dist/httpd/httpd-2.2.26.tar.bz2;
    md5 = "254eda547f8d624604e4bf403241e617";
  };

  httpdConf = ./conf/httpd.conf;
  httpdMime = ./conf/mime.types;
  httpdMagic = ./conf/magic;
  bin = ./bin;
  home = builtins.getEnv "HOME";
  
  buildInputs = [ gcc openssl zlib ];

  meta = {
    description = "Apache HTTP server.";
    homepage = http://httpd.apache.org/;
    license = "Apache2";
  };
}