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

  conveyor-composer = import ./pkgs/development/misc/conveyor-composer {
    inherit (pkgs) stdenv fetchurl;
  };

  conveyor-orientdb = import ./pkgs/servers/nosql/conveyor-orientdb {
    inherit (pkgs) stdenv patch perl fetchurl fetchFromGitHub;
    inherit conveyor-composer conveyor-php;
  };

  conveyor-php = import ./pkgs/development/interpreters/conveyor-php {
    # Needs apache tools to build apache PHP module.
    inherit conveyor-apache conveyor-mysql;
    # Dependencies from Nixpkgs
    inherit (pkgs) stdenv fetchurl gcc perl openssl zlib ncurses libxml2 libpng libjpeg curl gdbm icu imagemagick gettext readline libxslt libmcrypt freetype db4 bzip2 cacert;
    libiconv = pkgs.libiconvOrLibc;
    inherit (pkgs.xlibs) libXpm;
  };

  conveyor-less = import ./pkgs/development/interpreters/conveyor-less {
    inherit (pkgs) stdenv nodejs;
  };

  conveyor-jquery = import ./pkgs/development/libraries/conveyor-jquery {
    inherit (pkgs) stdenv fetchurl;
  };

  conveyor-jquery-sticky = import ./pkgs/development/libraries/conveyor-jquery-sticky {
    inherit (pkgs) stdenv fetchurl;
  };

  conveyor-icanhaz = import ./pkgs/development/libraries/conveyor-icanhaz {
    inherit (pkgs) stdenv fetchurl;
  };

  conveyor-twitter-bootstrap = import ./pkgs/development/web/conveyor-twitter-bootstrap {
    inherit (pkgs) stdenv fetchFromGitHub;# lessc closurecompiler;
  };

  conveyor-minify = import ./pkgs/development/web/conveyor-minify {
    inherit (pkgs) stdenv fetchFromGitHub;
  };

  conveyor-core = import ./pkgs/development/web/conveyor-core {
    inherit (pkgs) stdenv procps gnugrep gawk jre fetchFromGitHub;
  };

  conveyor-standards = import ./pkgs/data/documentation/conveyor-standards {
    inherit (pkgs) stdenv fetchFromGitHub;
    inherit conveyor-core;
  };

  conveyor-nix-documentation = import ./pkgs/data/documentation/conveyor-nix-documentation {
    inherit (pkgs) stdenv fetchFromGitHub;
    inherit conveyor-core;
  };

  conveyor-stack-documentation = import ./pkgs/data/documentation/conveyor-stack-documentation {
    inherit (pkgs) stdenv fetchFromGitHub;
    inherit conveyor-core conveyor-nix-documentation;
  };

  conveyor-environments = import ./pkgs/applications/networking/misc/conveyor-environments {
    inherit (pkgs) stdenv fetchzip;
  };
}
