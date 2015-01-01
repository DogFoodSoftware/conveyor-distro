{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "2.0-RC1";
  name = "conveyor-orientdb-${version}";

  builder = ./builder.sh;
  
  src = fetchurl {
    url = "http://www.orientechnologies.com/download.php?email=unknown@unknown.com\&file=orientdb-community-2.0-rc1.tar.gz\&os=linux";
    name = "orientdb-${version}.tar.gz";
    md5 = "9b762c782a76ba64c65d41e9e46ba469";
  };

  conveyor_bin = ./bin;
  orientdb_bin = ./bin-orientdb;
  conf = ./conf;

  home = builtins.getEnv "HOME";
  
  buildInputs = [ ];

  meta = {
    description = "OrientDB Server.";
    homepage = http://orientechnologies.com/orientdb/;
    license = "Apache2";
  };
}