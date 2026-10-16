{
  appimage-run,
  fetchurl,
  lib,
  stdenv,

  bashNonInteractive,
  ...
}:
let
  pname = "seanime-denshi";
  version = "3.10.4";
  src = fetchurl {
    url = "${meta.downloadPage}/download/v${version}/${pname}-${version}_Linux_x86_64.AppImage";
    hash = "sha256-vB07WwRbG+E3j0UBr8Q2vygsBS1fslRROt3y469wFPU=";
  };
  meta = {
    description = "An anime+manga browser|downloader|viewer";
    homepage = "https://seanime.app/";
    downloadPage = "https://github.com/5rahim/seanime/releases";
    license = lib.licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };

  out_exec = "$out/bin/${pname}";
  desktop = /* ini */ ''
    [Desktop Entry]
    Type=Applicaiton
    Exec=${out_exec}
    Icon=seanime
    Terminal=false

    Name=SeaAnime Denshi
    Comment=${meta.description}

    StartupNotify=true
    Categories=Network;Player;TV;Video;
    Keywords=${pname};seanime;denshi;anime;manga;torrent;
  '';
  launcher-script = /* sh */ ''
    #!${lib.getExe bashNonInteractive}
    ${lib.getExe appimage-run} $src
  '';
in
stdenv.mkDerivation {
  inherit
    pname
    version
    src
    meta
    ;

  buildInputs = [ appimage-run ];
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/{bin,share/applications}
    cp $src $out/bin/${pname}.AppImage

    cat > ./${pname}.sh << EOF
    ${launcher-script}
    EOF
    cat > ./${pname}.desktop << EOF
    ${desktop}
    EOF

    install -Dm 755 ${pname}.sh ${out_exec}
    install -Dm 644 ${pname}.desktop $out/share/applications/${pname}.desktop

    chmod +x $out/bin/${pname}
  '';
}
