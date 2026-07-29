{ config, pkgs, ... }:

let
  codeWhale = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "Hmbown/CodeWhale";
    version = "0.9.1";

    src = pkgs.fetchurl {
      url = "https://github.com/${pname}/releases/download/v${version}/codewhale-linux-x64.tar.gz";
      sha256 = "2450dca1cb2bd1a18e9d9b5a09125ecc78d01cf4aff932fab8859f027d9a6d34";
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
