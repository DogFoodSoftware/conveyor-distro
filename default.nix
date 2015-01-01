{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };
in
rec {
  conveyor-apache = import ./pkgs/servers/http/conveyor-apache {
    inherit (pkgs) stdenv fetchurl pkgconfig gcc openssl zlib perl;
  };

  conveyor-mysql = import ./pkgs/servers/sql/conveyor-mysql {
    inherit (pkgs) stdenv patchelf fetchurl pkgconfig gcc openssl zlib perl cmake bison ncurses;
  };

  conveyor-php = import ./pkgs/development/interpreters/conveyor-php {
    # Needs apache tools to build apache PHP module.
    inherit conveyor-apache conveyor-mysql;
    # Dependencies from Nixpkgs
    inherit (pkgs) stdenv fetchurl gcc perl openssl zlib ncurses libxml2 libpng libjpeg curl gdbm icu imagemagick libiconv gettext readline libxslt libmcrypt freetype db4 bzip2;
    inherit (pkgs.xlibs) libXpm;
  };

  conveyor-less = import ./pkgs/development/interpreters/conveyor-less {
    inherit (pkgs) stdenv nodejs;
  };

  conveyor-twitter-bootstrap = import ./pkgs/development/web/conveyor-twitter-bootstrap {
    inherit (pkgs) stdenv fetchFromGitHub;# lessc closurecompiler;
  };

  conveyor-minify = import ./pkgs/development/web/conveyor-minify {
    inherit (pkgs) stdenv fetchFromGitHub;
  };

  conveyor-core = import ./pkgs/development/web/conveyor-core {
    inherit (pkgs) stdenv fetchFromGitHub;
  };

  conveyor-environments = import ./pkgs/applications/networking/misc/conveyor-environments {
    inherit (pkgs) stdenv fetchzip;
  };
}