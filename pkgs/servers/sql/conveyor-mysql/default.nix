{ stdenv, fetchurl, perl, pkgconfig, gcc, openssl, zlib, cmake, bison, ncurses, patchelf }:

stdenv.mkDerivation {
  inherit perl;

  domain_name = "dogfoodsoftware.com";
  bare_name = "conveyor-mysql";
  version = "5.6.22";
  name = "${bare_name}-${version};

  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-${version}.tar.gz;
    md5 = "3985b634294482363f3d87e0d67f2262";
  };

  home = builtins.getEnv "HOME";
  
  buildInputs = [ gcc openssl zlib cmake bison ncurses patchelf ];

  meta = {
    description = "MySQL server.";
    homepage = http://mysql.com/;
    license = "GPL";
  };

  gcc_home = gcc;

  # 'gcc' points to the nix wrapper; gcc.gcc points to the 'real' gcc.
  libPath = stdenv.lib.makeLibraryPath [
    ncurses
    gcc.gcc
  ];
}