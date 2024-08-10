{ lib
, fetchFromGitHub
, rustPlatform
, expat
, freetype
, libX11
, libxcb
, libXcursor
, libXi
, libxkbcommon
, libXrandr
, vulkan-loader
, wayland
}: let
  pname = "pigg";
  version = "0.3.4";
  rpathLibs = [
    libXcursor
    libXi
    libxkbcommon
    libXrandr
    libX11
    vulkan-loader
    wayland
  ];
in
  rustPlatform.buildRustPackage {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "andrewdavidmackenzie";
      repo = "pigg";
      rev = version;
      hash = "sha256-u9QMkjlgCYDWvoojeVx2vpheiAo+A3BExQvZCowp4Tc=";
    };
    cargoHash = "sha256-wJxPmZear/VbKhxFeHr059rZXD2W8x12HUKsYI5t8Gs=";

    buildInputs = [
      expat
      freetype
      libxcb
      libX11
      libxkbcommon
    ];

    fixupPhase = ''
      patchelf --add-rpath "${lib.makeLibraryPath rpathLibs}" $out/bin/piggui
    '';

    # error: "Found argument '--test-threads' which wasn't expected, or isn't valid in this context"
    doCheck = false;

    meta = with lib; {
      description = "Raspberry Pi GPIO GUI";
      homepage = "https://github.com/andrewdavidmackenzie/pigg";
      licence = licences.asl20;
      maintainers = with maintainers; [ henrispriet ];
    };
  }
