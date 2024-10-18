{
  stdenv,
  callPackage,

  # Hooks
  autoPatchelfHook,

  # Deps
  unar,
  curl,
  gcc-unwrapped,
  freetype,
  alsa-lib,
  mecab,
  iconv,

  # An url and hash of Voicepeak's zip archive
  url,
  hash,
}:

let
  src = callPackage ./source {
    inherit url hash;
  };
in

stdenv.mkDerivation {
  pname = "voicepeak";
  version = "1.2.11";

  inherit src;

  nativeBuildInputs = [
    unar
    autoPatchelfHook
  ];

  buildInputs = [
    (curl.overrideAttrs (oldAttrs: {
      configureFlags = oldAttrs.configureFlags ++ [ "--enable-versioned-symbols" ];
    }))
    gcc-unwrapped
    freetype
    alsa-lib
    mecab
    iconv
  ];

  unpackPhase = ''
    unar -D -e shift-jis -o $TMP $src/Voicepeak-linux64.zip
  '';

  installPhase = ''
    mkdir -p $out/opt
    mkdir -p $out/bin

    cp -r $TMP/Voicepeak/* $out/opt
    ln -s $out/opt/voicepeak $out/bin/voicepeak
  '';
}
