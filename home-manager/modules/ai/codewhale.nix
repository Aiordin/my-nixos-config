{ config, pkgs, ... }:

let
  codeWhale = pkgs.stdenv.mkDerivation rec {
    pname = "Hmbown/CodeWhale";
    version = "0.9.1";

    # fetchurl 只下载不解压，校验的是压缩包原始文件的哈希
    src = pkgs.fetchurl {
      url = "https://github.com/${pname}/releases/download/v${version}/codewhale-linux-x64.tar.gz";
      # 这里可以填写 GitHub 提供的 64 位十六进制原始哈希
      sha256 = "2450dca1cb2bd1a18e9d9b5a09125ecc78d01cf4aff932fab8859f027d9a6d34";
    };

    nativeBuildInputs = [ 
      pkgs.autoPatchelfHook 
      pkgs.gnutar
      pkgs.gzip
    ];
    
    buildInputs = [ pkgs.stdenv.cc.cc.lib ];

    # 声明解压阶段
    unpackPhase = ''
      tar -xzf $src
      # 此时当前目录就是解压后的内容，即您之前 ls 看到的目录
      cd codewhale-linux-x64
    '';

    # 此时 $src 变成了当前目录，所以去掉之前的 $src/ 前缀，直接复制当前目录的文件
    installPhase = ''
      mkdir -p $out/bin
      cp codew codewhale codewhale-tui $out/bin/
      chmod +x $out/bin/*
    '';
  };
in
{
  home.packages = [ codeWhale ];
}
