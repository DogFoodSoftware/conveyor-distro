{ stdenv, fetchurl, perl, pkgconfig, gcc, openssl, zlib, conveyor-core, conveyor-install-lib }:

stdenv.mkDerivation rec {
  inherit perl;

  domain = "dogfoodsoftware.com";
  bare_name = "conveyor-apache";
  version = "2.2.29";
  name = "${bare_name}-${version}";

  builder = ./builder.sh;
  
  src = fetchurl {
    url = "http://archive.apache.org/dist/httpd/httpd-${version}.tar.bz2";
    md5 = "579342fdeaa7b8b68d17fee91f8fab6e";
    # md5 = "254eda547f8d624604e4bf403241e617";
  };

  httpdConf = ./conf/httpd.conf;
  httpdMime = ./conf/mime.types;
  httpdMagic = ./conf/magic;
  httpdInit = conf/apache-httpd.init;
  bin = ./bin;
  home = builtins.getEnv "HOME";
  install_lib = conveyor-install-lib + /conveyor-install-lib.sh;
  
  buildInputs = [ gcc openssl zlib ];

  configureFlags = [ "--enable-dav=shared"
                     "--enable-dav-fs=shared"
		     "--enable-ssl=shared"
		     "--enable-so"
		     "--enable-rewrite=shared"
		     "--enable-deflate=shared"
		     "--with-z=${zlib}" ];

  meta = {
    description = "Apache HTTP server.";
    homepage = http://httpd.apache.org/;
    license = "Apache2";
  };
}
