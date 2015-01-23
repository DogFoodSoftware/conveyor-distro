{ stdenv, fetchFromGitHub, conveyor-core }:

stdenv.mkDerivation rec {
  version = "0.1.3-PRE";
  bare-name = "nix-documentation";
  name = "conveyor-${bare-name}-${version}";

  home = builtins.getEnv "HOME";

  test_path = builtins.toPath home + "/playground/dogfoodsoftware.com/conveyor/${bare-name}";
  src = if builtins.pathExists test_path
    then test_path
    else fetchFromGitHub {
      owner = "DogFoodSoftware";
      repo = "${bare-name}";
      # These values are bogus.
      rev =  "155cc95b2e3fc242f66cf23c45218bb70e0cc131";
      sha256 = "18x2rmdb64kzd8bnh3sfyyfla8yvhs8cz7d755277p01jcljlp6v";
    };

  buildInputs = [ conveyor-core ];

  phases = [ "installPhase" ];

  installPhase = ''
    INSTALL_DIR=$out/$name
    RUNTIME_LINK=$home/.conveyor/runtime/dogfoodsoftware.com/${name}

    if [[ $test_path == $src ]]; then
      mkdir -p $out
      ln -s $src $INSTALL_DIR
    else
      mkdir -p $INSTALL_DIR
      cp -a $src/* $INSTALL_DIR
    fi

    echo "Creating runtime link..."
    mkdir -p `basename $RUNTIME_LINK`
    rm -f $RUNTIME_LINK
    ln -s $INSTALL_DIR $RUNTIME_LINK

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