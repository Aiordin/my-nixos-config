{ config, pkgs, ... }:

let
  codeWhale = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "Hmbown/CodeWhale";
    version = "0.9.5";

    src = pkgs.fetchurl {
      url = "https://github.com/${pname}/releases/download/v${version}/codewhale-linux-x64.tar.gz";
      sha256 = "fd64cb8e83283f292ed3d7cad96cc2390edaf73f273dfb132e32e899012d0a85";
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
