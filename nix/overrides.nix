{ lib
, haskell
, symlinkJoin
, ...
}:
with lib;
with haskell.lib;
self: super:
let
  conformancePackages =
    let
      conformancePkg = name:
        buildFromSdist (
          overrideCabal (self.callPackage (../${name}) { })
            (old: {
              doBenchmark = true;
              configureFlags = (old.configureFlags or [ ]) ++ [
                # Optimisations
                "--ghc-options=-O2"
                # Extra warnings
                "--ghc-options=-Wall"
                "--ghc-options=-Wincomplete-uni-patterns"
                "--ghc-options=-Wincomplete-record-updates"
                "--ghc-options=-Wpartial-fields"
                "--ghc-options=-Widentities"
                "--ghc-options=-Wredundant-constraints"
                "--ghc-options=-Wcpp-undef"
                "--ghc-options=-Werror"
                "--ghc-options=-Wno-deprecations"
              ];
              # Ugly hack because we can't just add flags to the 'test' invocation.
              # Show test output as we go, instead of all at once afterwards.
              testTarget = (old.testTarget or "") + " --show-details=direct";
            })
        );
    in
    {
      conformance = conformancePkg "conformance";
      conformance-gen = conformancePkg "conformance-gen";
    };
in
{
  inherit conformancePackages;
  conformanceRelease = symlinkJoin {
    name = "conformance-release";
    paths = attrValues self.conformancePackages;
  };
} // conformancePackages
