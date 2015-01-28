{ stdenv, fetchurl, fetchFromGitHub, conveyor-composer, conveyor-php }:

stdenv.mkDerivation rec {
  version = "2.0";
  name = "conveyor-orientdb-${version}";

  builder = ./builder.sh;
  
  src = fetchurl {
    url = "http://www.orientechnologies.com/download.php?email=unknown@unknown.com&file=orientdb-community-2.0.tar.gz&os=linux";
    name = "orientdb-${version}.tar.gz";
    md5 = "0f125aa92dd23a52bcc49737970e0dce";
  };

  client_src = fetchFromGitHub {
    owner = "Ostico";
    repo = "PhpOrient";
    rev = "9be2f69dedfbc5a6edf49d4306310927b66f8098";
    sha256 = "1nlz4c4ryzsikc7bbhzlz4di616mmaavi6gywgql4srsbqs7cyjq";
  };

  conveyor_bin = ./bin;
  orientdb_bin = ./bin-orientdb;
  conf = ./conf;

  home = builtins.getEnv "HOME";
  conveyor_composer = conveyor-composer;
  
  buildInputs = [ conveyor-composer conveyor-php ];

  meta = {
    description = "OrientDB Server.";
    homepage = http://orientechnologies.com/orientdb/;
    license = "Apache2";
  };
}