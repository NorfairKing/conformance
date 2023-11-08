{ mkDerivation, base, lib, mtl }:
mkDerivation {
  pname = "conformance";
  version = "0.1.0.0";
  src = ./.;
  libraryHaskellDepends = [ base mtl ];
  license = lib.licenses.mit;
}
