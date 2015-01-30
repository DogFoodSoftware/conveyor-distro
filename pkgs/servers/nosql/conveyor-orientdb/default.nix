{ stdenv, patch, perl, fetchurl, fetchFromGitHub, conveyor-composer, conveyor-php }:

stdenv.mkDerivation rec {
  domain_name = "dogfoodsoftware.com";
  version = "2.0";
  bare_name = "conveyor-orientdb";
  name = "${bare_name}-${version}";

  builder = ./builder.sh;
  
  src = fetchurl {
    url = "http://www.orientechnologies.com/download.php?email=unknown@unknown.com&file=orientdb-community-${version}.tar.gz&os=linux";
    name = "orientdb-${version}.tar.gz";
    md5 = "0f125aa92dd23a52bcc49737970e0dce";
  };

  client_src = fetchFromGitHub {
    owner = "Ostico";
    repo = "PhpOrient";
    rev = "9be2f69dedfbc5a6edf49d4306310927b66f8098";
    sha256 = "0hykhphy4b2m5r7wfshp07ajsqbkrcjqgjhn513d3r0aqg66db4w";
  };

  bin_patches = [ ./patches/orientdb.patch ];
  obin_patches = [ ./patches/console.sh.patch ];
  orientdb_console_bin = ./bin/orientdb-console;
  conf = ./conf;

  home = builtins.getEnv "HOME";
  conveyor_composer = conveyor-composer;
  
  buildInputs = [ patch perl conveyor-composer conveyor-php ];

  meta = {
    description = "OrientDB Server.";
    homepage = http://orientechnologies.com/orientdb/;
    license = "Apache2";
  };
}
