{ stdenv, fetchurl, perl, pkgconfig, gcc, openssl, zlib, cmake, bison, ncurses, conveyor-mysql, patchelf }:

stdenv.mkDerivation {
  inherit perl;

  name = "test";

  home = builtins.getEnv "HOME";
  
  buildInputs = [ ncurses conveyor-mysql ];

  meta = {
    description = "MySQL server.";
    homepage = http://mysql.com/;
    license = "GPL";
  };

  libPath = stdenv.lib.makeLibraryPath [
    stdenv.gcc.gcc
    ncurses
  ];

  mysql = conveyor-mysql;

  phases = [ "installPhase" ];

  installPhase = ''
    source $stdenv/setup 1

    PATH=$perl/bin:$PATH

    echo LIBPATH: $libPath

    f=$mysql/bin/mysql
    chmod -R u+w $mysql
    patchelf \
      --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
      --set-rpath "$(patchelf --print-rpath "$f"):$libPath" \
      "$f"
    patchelf --shrink-rpath "$f"

    mkdir $out
    touch $out/yeah
  '';
}