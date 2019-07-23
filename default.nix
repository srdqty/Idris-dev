{ nixpkgs ? import ./nixpkgs/c49b7f64d15dfd6f68e7bd1dd1f1f862f8840ff8 {}
, ghcWithPackages ? nixpkgs.haskell.packages.ghc865.ghcWithPackages
, mkDerivation ? nixpkgs.stdenv.mkDerivation
, ncurses ? nixpkgs.ncurses
, gmp ? nixpkgs.gmp
, fetchgit ? nixpkgs.fetchgit
, pkgconfig ? nixpkgs.pkgconfig
, perl ? nixpkgs.perl
, glibcLocales ? nixpkgs.glibcLocales
}:

let
  ghc = nixpkgs.haskell.packages.ghc865.ghcWithPackages (ps: with ps; [
    aeson annotated-wl-pprint ansi-terminal ansi-wl-pprint array async
    base base64-bytestring binary blaze-html blaze-markup bytestring
    cheapskate code-page containers deepseq directory filepath
    fingertree fsnotify haskeline ieee754 libffi megaparsec mtl network
    optparse-applicative parser-combinators pretty process regex-tdfa
    safe split terminal-size text time transformers uniplate unix
    unordered-containers utf8-string vector vector-binary-instances
    zip-archive

    tagged tasty tasty-golden tasty-rerun

    cabal-install

    stylish-haskell
  ]);

  envVars = ''
    # cabal install blows up at the end if this directory doesn't exist...
    mkdir -p $TMP/home/.cabal/bin
    export IDRIS_LIB_DIR=..
    export HOME=$TMP/home
  '';

in
  mkDerivation rec {
    name = "idris-${version}";
    version = builtins.substring 0 7 src.rev;

    src = fetchgit {
      url = "https://github.com/idris-lang/idris-dev";
      rev = "9549d9cb9ac5922154f3a11504df7d2488f0cd72";
      sha256 = "05jpw4f4r1wxlllcj5g7md1b9lg0ikvslra3v4m6pg00k5sz9f1f";
    };

    configurePhase = envVars + ''
      cabal configure --prefix=$out --datadir=$out --datasubdir="" -fgmp -fffi -ffreestanding --disable-profiling --disable-library-profiling
    '';

    buildPhase = envVars + ''
      echo CABALFLAGS= \
        --verbose \
        --prefix=$out \
        --datadir=$out \
        '--datasubdir=""' \
        -fgmp \
        -fffi \
        -ffreestanding \
        --disable-profiling \
        --disable-library-profiling \
        > custom.mk

      make install
    '';

    doCheck = true;

    checkPhase = envVars + ''
      export IDRIS="$out/bin/idris"

      echo "CABALFLAGS=" > custom.mk
      make test
    '';

    installPhase = "true";

    buildInputs = [
      ncurses
      gmp
      ghc
      glibcLocales
      perl
      pkgconfig
    ];

    LANG = "en_US.UTF-8";
  }
