{ stdenv, fetchurl, fetchFromGitHub, conveyor-composer }:

stdenv.mkDerivation rec {
  version = "2.0-RC1";
  name = "conveyor-orientdb-${version}";

  builder = ./builder.sh;
  
  src = fetchurl {
    url = "http://www.orientechnologies.com/download.php?email=unknown@unknown.com\&file=orientdb-community-2.0-rc1.tar.gz\&os=linux";
    name = "orientdb-${version}.tar.gz";
    md5 = "9b762c782a76ba64c65d41e9e46ba469";
  };

  client_src = fetchFromGitHub {
    owner = "Ostico";
    repo = "PhpOrient";
    rev = "4a56e38c9eaa7c4c1fd5748b43c27fc4df356eb4";
    sha256 = "1nlz4c4ryzsikc7bbhzlz4di616mmaavi6gywgql4srsbqs7cyjq";
  };

  conveyor_bin = ./bin;
  orientdb_bin = ./bin-orientdb;
  conf = ./conf;

  home = builtins.getEnv "HOME";
  
  buildInputs = [ conveyor-composer ];

  meta = {
    description = "OrientDB Server.";
    homepage = http://orientechnologies.com/orientdb/;
    license = "Apache2";
  };
}