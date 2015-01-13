{ stdenv, fetchurl, gcc, perl, openssl, libiconv, gettext, zlib, readline, ncurses, libxslt, libmcrypt, libxml2, libpng, libjpeg, freetype, curl, icu, gdbm, db4, libXpm, imagemagick, bzip2, cacert, conveyor-apache, conveyor-mysql }:

let
  home = builtins.getEnv "HOME";
  test_path = builtins.toPath home + "/playground/dogfoodsoftware.com/distro";
  libmcryptOverride = libmcrypt.override { disablePosixThreads = true; };
in

stdenv.mkDerivation {
  inherit perl;
  inherit home test_path;

  name = "conveyor-php-5.6.4";

  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://us1.php.net/get/php-5.6.4.tar.bz2/from/this/mirror;
    md5 = "d31629e9c2fb5f438ab2dc0aa597cd82";
  };

  is_devel = if builtins.pathExists test_path
    then true
    else false;

  apache_home = conveyor-apache;
  mysql_home = conveyor-mysql;
  php_http_conf = ./conf/php5.httpd.conf;
  php_ini_production = ./conf/php.ini.production;
  php_ini_development = ./conf/php.ini.development;
  php_cli_ini = ./conf/php-cli.ini;
  gettext_home = gettext;
  
  buildInputs = [ gcc openssl db4 zlib ncurses libxml2 libpng libjpeg freetype curl libmcryptOverride libxslt libiconv gdbm libXpm gettext imagemagick icu bzip2 readline conveyor-apache conveyor-mysql ];

  configureFlags = ["--enable-calendar"
		    "--disable-cgi"
		    "--with-pic"
		    "--enable-inline-optimization"
		    "--enable-exif"
		    "--enable-shmop"
		    "--enable-sysvshm"
		    "--enable-mbstring"
		    "--enable-phar"
		    "--enable-bcmath"
		    "--enable-sockets"
		    "--enable-intl"
		    "--enable-zip"
		    "--with-curl=${curl}"
		    "--with-zlib=${zlib}"
		    "--with-libxml-dir=${libxml2}"
		    "--with-readline=${readline}"
		    "--with-gdbm=${gdbm}"
		    "--with-db4=${db4}"
# From nixpkgs php/5.4.nix:
# FIXME: Our own gd package does not work, see https://bugs.php.net/bug.php?id=60108.
		    "--with-gd"
		    "--with-freetype-dir=${freetype}"
		    "--with-png-dir=${libpng}"
		    "--with-jpeg-dir=${libjpeg}"
		    "--with-gettext=${gettext}"
		    "--with-openssl=${openssl}"
		    "--with-iconv-dir=${libiconv}"
		    "--with-bz2=${bzip2}"
		    "--with-xsl=${libxslt}"
		    "--with-mcrypt=${libmcrypt}"
		    "--without-sqlite3"
		    "--without-pdo-sqlite"
		    ];

#  configureFlags = ["--with-pgsql=${postgresql}"];
#  buildInputs = [ postgresql ];

#  configureFlags = ["--with-mysql=${mysql}"];
#  buildInputs = [ mysql ];

  meta = {
    description = "PHP interpreter configured for standard Conveyor distro.";
    homepage = http://php.net;
    license = "PHP-3";
  };
}
