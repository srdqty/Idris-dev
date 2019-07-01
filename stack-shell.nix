with (import ./nixpkgs/c49b7f64d15dfd6f68e7bd1dd1f1f862f8840ff8 {});

let
  libs = [
    gmp
    libffi
    ncurses
    nodejs
    perl
    zlib
  ];
  native_libs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    Cocoa
    CoreServices
  ]);

in haskell.lib.buildStackProject {
  ghc = haskell.compiler.ghc865;
  nativeBuildInputs = native_libs;
  buildInputs = libs;
  name = "idrisBuildEnv";
  src = if lib.inNixShell then null else ./.;
}
