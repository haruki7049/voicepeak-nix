{
  stdenv,
  fetchurl,
  unar,

  # An url and hash of Voicepeak's zip archive
  url,
  hash,
}:

stdenv.mkDerivation {
  pname = "voicepeak-src";
  version = "1.2.11";

  src = fetchurl {
    inherit url hash;
  };

  nativeBuildInputs = [
    unar
  ];

  unpackPhase = ''
    unar -D -e shift-jis -o $TMP $src
  '';

  installPhase = ''
    mkdir $out
    cp $TMP/VOICEPEAK\ 1.2.11/Linux/Voicepeak-linux64.zip $out
  '';
}
