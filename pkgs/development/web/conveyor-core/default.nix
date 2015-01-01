{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "conveyor-core";

  home = builtins.getEnv "HOME";
  
  test_path = builtins.toPath home + "/playground/dogfoodsoftware.com/conveyor/core";
  src = if builtins.pathExists test_path
    then test_path
    else fetchFromGitHub {
      owner = "DogFoodSoftware";
      repo = "conveyor-core";
      # Following not updated yet
      rev =  "db7fe244932ea77cf1438965693672ea12b33da8";
      sha256 = "1a1567vpbjb8q71pxsr4kpnw1qvi9p7i61pky8mp4m27z4hh6h4r";
    };

  phases = [ "installPhase" ];

  installPhase = ''
    # Always create package context to avoid name collisions.
    INSTALL_DIR=$out/conveyor-core
    RUNTIME_LINK=$home/.conveyor/runtime/dogfoodsoftware.com/conveyor-core

    if [[ "$src" == "$test_path" ]]; then
      mkdir -p `dirname $INSTALL_DIR`
      ln -s $src $INSTALL_DIR
    else 
      mkdir -p $INSTALL_DIR
      cp -a $src/* $INSTALL_DIR
    fi
    
    echo "Creating runtime link..."
    mkdir -p `basename $RUNTIME_LINK`
    rm -f $RUNTIME_LINK
    ln -s $INSTALL_DIR $RUNTIME_LINK
  ''; 

  # meta = {
  #   description = "Something...";
  #   homepage = http://dogfoodsoftware.com/projects/conveyor-core/;
  # };
}