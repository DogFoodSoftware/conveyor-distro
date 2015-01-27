{ stdenv, nodejs }:

stdenv.mkDerivation rec {
  name = "conveyor-less";

  buildInputs = [ nodejs ];

  phases = [ "installPhase" ];

  home = builtins.getEnv "HOME";

  installPhase = ''
    # Always create package context to avoid name collisions.
    INSTALL_DIR=$out/conveyor-less

    mkdir -p $INSTALL_DIR
    cd $INSTALL_DIR

    # Seems a little silly, but keeps our vars pure. Actually, not
    # sure what the best nix-ish approach is. In any case...

    # Need to define 'HOME' so npm can find the '.npm' dir, which
    #  defines the packages, like 'less'.
    export HOME="$home"
    npm install less

    mkdir $out/bin
    ln -s $INSTALL_DIR/node_modules/less/bin/lessc $out/bin/lessc
  ''; 

  meta = {
    description = "Conveyor installation of LESS.";
    homepage = http://lesscss.org;
  };
}