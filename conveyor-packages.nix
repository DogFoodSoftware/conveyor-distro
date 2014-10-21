{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };
in
rec {
  conveyor-apache = import ./pkgs/servers/http/conveyor-apache {
    # Dependencies from Nixpkgs
    inherit (pkgs) stdenv fetchurl pkgconfig gcc openssl zlib perl;
  };
}