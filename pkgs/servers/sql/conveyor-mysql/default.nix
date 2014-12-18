{ stdenv, fetchurl, perl, pkgconfig, gcc, openssl, zlib, cmake, bison, ncurses, patchelf }:

stdenv.mkDerivation {
  inherit perl;

  name = "conveyor-mysql-5.6.22";

  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.22.tar.gz;
    md5 = "3985b634294482363f3d87e0d67f2262";
  };

  home = builtins.getEnv "HOME";
  
  buildInputs = [ gcc openssl zlib cmake bison ncurses patchelf ];

  meta = {
    description = "MySQL server.";
    homepage = http://mysql.com/;
    license = "GPL";
  };

  # 'gcc' points to the nix gcc wraper, 'gcc.gcc' points to the 'real'
  #  underlying gcc package.

  libPath = stdenv.lib.makeLibraryPath [
    ncurses
    stdenv.gcc.gcc
  ];
}