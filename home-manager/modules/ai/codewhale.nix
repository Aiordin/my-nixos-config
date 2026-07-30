{ config, pkgs, ... }:

let
  codeWhale = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "Hmbown/CodeWhale";
    version = "0.9.2";

    src = pkgs.fetchurl {
      url = "https://github.com/${pname}/releases/download/v${version}/codewhale-linux-x64.tar.gz";
      sha256 = "fceb7eb3f49f1dac78823425f74ea2a0c69f8e807bc40937d0198c0dfadeb173";
    };

    unpackPhase = ''
      tar -xzf $src
      cd codewhale-linux-x64
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp codew codewhale codewhale-tui $out/bin/
      chmod +x $out/bin/*
    '';
  };
in
{
  home.packages = [
    codeWhale
    # codewhale-tui 剪贴板支持：Wayland (niri) 下需要 wl-clipboard 才能把内容复制到系统剪贴板
    # 对 X11 环境可替换为 pkgs.xclip
    pkgs.wl-clipboard
  ];
}
