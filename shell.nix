let
  nixpkgs = import ./nixpkgs/c49b7f64d15dfd6f68e7bd1dd1f1f862f8840ff8 {};

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
  ]);
in
  nixpkgs.stdenv.mkDerivation {
    name = "idris-dev-shell";

    buildInputs = [
      nixpkgs.ncurses
      nixpkgs.gmp
      ghc
    ];

    shellHook = builtins.readFile ./nixpkgs/bash-prompt.sh;
  }
