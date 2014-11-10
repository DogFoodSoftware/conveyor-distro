{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };
in
rec {
  conveyor-apache = import ./pkgs/servers/http/conveyor-apache {
    inherit (pkgs) stdenv fetchurl pkgconfig gcc openssl zlib perl;
  };

  conveyor-php = import ./pkgs/development/interpreters/conveyor-php {
    # Needs apache tools to build apache PHP module.
    inherit conveyor-apache;
    # Dependencies from Nixpkgs
    inherit (pkgs) stdenv fetchurl gcc perl openssl zlib ncurses libxml2 libpng libjpeg curl gdbm icu imagemagick libiconv gettext readline libxslt libmcrypt freetype db4 bzip2;
    inherit (pkgs.xlibs) libXpm;
  };
}