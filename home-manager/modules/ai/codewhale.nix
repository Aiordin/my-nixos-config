{ config, pkgs, ... }:

let
  codeWhale = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "Hmbown/CodeWhale";
    version = "0.9.6";

    src = pkgs.fetchurl {
      url = "https://github.com/${pname}/releases/download/v${version}/codewhale-linux-x64.tar.gz";
      sha256 = "18f72ad40af021d80ed913b94bbfe772f56f9f297745f19107bdcb24ed37bf42";
    };

    unpackPhase = ''
      tar -xzf $src
      cd codewhale-linux-x64
    '';

    installPhase = ''
      mkdir -p $out/bin
      # v0.9.5 起为单二进制：归档内只有 codew / codewhale（install.sh 为官方安装脚本，此处直接用二进制）
      cp codew codewhale $out/bin/
      chmod +x $out/bin/*
    '';
  };
in
{
  home.packages = [
    codeWhale
    # codewhale-tui 剪贴板支持：Wayland (niri) 下需要 wl-clipboard 才能把内容复制到系统剪贴板
    # 对 X11 环境可替换为 pkgs.xclip
    # pkgs.wl-clipboard
  ];
}
