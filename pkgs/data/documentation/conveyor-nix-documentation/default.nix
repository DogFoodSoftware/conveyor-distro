{ stdenv, fetchFromGitHub, conveyor-core }:

stdenv.mkDerivation rec {
  bare-name = "conveyor-nix-documentation";
  version = "0.1.4-PRE";
  name = "${bare-name}-${version}";

  home = builtins.getEnv "HOME";

  test_path = builtins.toPath home + "/playground/dogfoodsoftware.com/${bare-name}";
  src = if builtins.pathExists test_path
    then test_path
    else fetchFromGitHub {
      owner = "DogFoodSoftware";
      # These values are bogus.
      repo = "${name}";
      rev =  "155cc95b2e3fc242f66cf23c45218bb70e0cc131";
      sha256 = "18x2rmdb64kzd8bnh3sfyyfla8yvhs8cz7d755277p01jcljlp6v";
    };

  buildInputs = [ conveyor-core ];

  phases = [ "installPhase" ];

  bare_name = bare-name;
  installPhase = ''
    INSTALL_DIR=$out/conveyor/$bare_name

    if [[ $test_path == $src ]]; then
      mkdir -p `dirname $INSTALL_DIR`
      ln -s $src $INSTALL_DIR
    else
      mkdir -p $INSTALL_DIR
      cp -a $src/* $INSTALL_DIR
    fi

    # For now, we manually finagle the documentation database. In
    # future, this will be done with something like:
    #
    # con POST /documentation/</organizations relative ID>[<optional sub dir>] action=mount
    # con PUT /documentation/</organizations relative ID>[<optional sub dir>] '{ ... patch spec }'
    function link_docs() {
      local SOURCE_DIR="$1"
      local TARGET_DIR="$2"

      cd "$SOURCE_DIR"

      for i in `ls $DIR`; do
        if [[ -d $i ]]; then
	  mkdir -p "$TARGET_DIR/$i"
	  link_docs "$SOURCE_DIR/$i" "$TARGET_DIR/$i"
	else
	  rm -f "$TARGET_DIR/$i"
	  ln -s "$SOURCE_DIR/$i" "$TARGET_DIR/$i"
	fi
      done
    };

    link_docs "$INSTALL_DIR/documentation" "${home}/.conveyor/data/dogfoodsoftware.com/conveyor-core/documentation"
  '';
}
