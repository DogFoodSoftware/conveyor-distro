source $stdenv/setup 1

PATH=$perl/bin:$PATH

echo patchelf --set-interpretter $(cat $NIX_GCC/nix-support/dynamic-linker) --set-rpath $libPath $mysql/bin/mysql

patchelf --set-interpretter $(cat $NIX_GCC/nix-support/dynamic-linker) \
  --set-rpath $libPath $mysql/bin/mysql
