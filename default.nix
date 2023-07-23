{ lib
, stdenv
, pkgs
, fetchurl
, appimageTools
, makeWrapper
, electron_22
}:

let
  electron = electron_22;
in
stdenv.mkDerivation rec {
  pname = "anytype";
  version = "0.33.3";

  src = fetchurl {
    url = "https://github.com/anyproto/anytype-ts/releases/download/v${version}/Anytype-${version}.AppImage";
    sha256 = "sha256-3qBd1WgHn/sfEyNRPTX5viMX3lVZPfsG6x7GfNwkL3E=";
    name = "${pname}-${version}.AppImage";
  };

  appimageContents = appimageTools.extractType2 {
    name = "${pname}-${version}";
    inherit src;

    extraPkgs = pkgs: with pkgs; [ libsecret xdg-utils ];
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/${pname} $out/share/applications

    cp -a ${appimageContents}/{locales,resources} $out/share/${pname}
    cp -a ${appimageContents}/anytype.desktop $out/share/applications/${pname}.desktop
    cp -a ${appimageContents}/usr/share/icons $out/share

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/share/${pname}/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc pkgs.libsecret ]}"
  '';

  meta = with stdenv.lib; {
    description = "Official Anytype client for MacOS, Linux, and Windows.";
    homepage = "https://github.com/anyproto/anytype-ts";
    platforms = [ "x86_64-linux" ];
  };
}
