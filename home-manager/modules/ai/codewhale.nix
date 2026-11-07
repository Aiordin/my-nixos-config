{ config, lib, pkgs, ... }:

let
  pluginsDir = ./codewhale-plugins;

  # 每次 home-manager switch 时检查上游最新 release，有新版才下载。
  # 官方二进制是静态链接的，解压到 ~/.local/share/codewhale 即可直接运行，
  # 不占用 Nix store，也就不需要手动改 version/sha256。
  # 离线或下载失败时保留现有安装，不会让 switch 失败。
  codewhaleUpdate = pkgs.writeShellScript "update-codewhale" ''
    set -u

    data_dir="$HOME/.local/share/codewhale"
    bin_dir="$HOME/.local/bin"
    marker="$data_dir/version"

    mkdir -p "$data_dir" "$bin_dir"

    latest=$(${pkgs.curl}/bin/curl -fsSL -o /dev/null -w '%{url_effective}' \
      "https://github.com/codewhale-hq/Codewhale/releases/latest" 2>/dev/null \
      | ${pkgs.gnused}/bin/sed -E 's|.*/tag/v?||') || latest=""

    if [ -z "$latest" ]; then
      echo "codewhale: 无法查询上游版本，保留现有安装" >&2
      exit 0
    fi

    if [ "$(cat "$marker" 2>/dev/null || true)" = "$latest" ]; then
      echo "codewhale: 已是最新 $latest"
      exit 0
    fi

    tmp=$(${pkgs.coreutils}/bin/mktemp -d)
    staging=""
    trap '${pkgs.coreutils}/bin/rm -rf "$tmp" "$staging"' EXIT

    url="https://github.com/codewhale-hq/Codewhale/releases/download/v$latest/codewhale-linux-x64.tar.gz"
    if ! ${pkgs.curl}/bin/curl -fsSL -o "$tmp/cw.tar.gz" "$url"; then
      echo "codewhale: 下载失败，保留现有安装" >&2
      exit 0
    fi

    # 不能用 tar 的 -z：它依赖 PATH 里的 gzip，而 activation 环境的 PATH
    # 不含 gzip，会以 "gzip：无法 exec：没有那个文件或目录" 失败。
    if ! ${pkgs.gnutar}/bin/tar -xf "$tmp/cw.tar.gz" \
      --use-compress-program="${pkgs.gzip}/bin/gzip" -C "$tmp"; then
      echo "codewhale: 解压失败，保留现有安装" >&2
      exit 0
    fi

    # 先落到暂存目录，再用 mv（rename）原子替换。直接 cp 覆盖正在运行的
    # 二进制会得到 ETXTBSY（文本文件忙），而 rename 不会。
    staging="$data_dir/.staging.$$"
    ${pkgs.coreutils}/bin/rm -rf "$staging"
    ${pkgs.coreutils}/bin/mkdir -p "$staging"

    if ! ${pkgs.coreutils}/bin/cp "$tmp/codewhale-linux-x64/codew" \
      "$tmp/codewhale-linux-x64/codewhale" "$staging/"; then
      echo "codewhale: 复制失败，保留现有安装" >&2
      exit 0
    fi

    ${pkgs.coreutils}/bin/chmod +x "$staging/"*

    mkdir -p "$data_dir/bin"
    if ! ${pkgs.coreutils}/bin/mv -f "$staging/codew" "$staging/codewhale" \
      "$data_dir/bin/"; then
      echo "codewhale: 替换失败，保留现有安装" >&2
      exit 0
    fi

    # 只有二进制已经就位才写 marker，避免留下“版本号已更新、文件还是旧的”状态
    printf '%s\n' "$latest" > "$marker"

    ${pkgs.coreutils}/bin/ln -sf "$data_dir/bin/codewhale" "$bin_dir/codewhale"
    ${pkgs.coreutils}/bin/ln -sf "$data_dir/bin/codew" "$bin_dir/codew"
    echo "codewhale: 已更新到 $latest"
  '';
in
{
  # ~/.local/bin 在 PATH 中优先于 ~/.nix-profile/bin
  home.sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];

  # 再在 profile 里放一层 wrapper：~/.nix-profile/bin 一直在这个 session 的
  # PATH 里，所以 switch 完当前 shell 不用重新加载也能直接用。
  home.packages = [
    (pkgs.writeShellScriptBin "codewhale" ''
      exec "$HOME/.local/share/codewhale/bin/codewhale" "$@"
    '')
    (pkgs.writeShellScriptBin "codew" ''
      exec "$HOME/.local/share/codewhale/bin/codew" "$@"
    '')
  ];

  home.activation.codewhaleUpdate =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run ${codewhaleUpdate}
    '';

  # ---------------------------------------------------------------------------
  # 声明式插件
  #
  # Codewhale 从 ~/.codewhale/plugins/<name>/ 发现插件（plugin.json /
  # kimi.plugin.json / plugin.toml / .claude-plugin/plugin.json），但它对
  # symbolic-link 的插件根会 fail closed，所以这里用 activation 复制真实文件，
  # 而不是 home.file 的符号链接。
  #
  # 用法：把插件目录放到 home-manager/modules/ai/codewhale-plugins/<name>/，
  # 然后 home-manager switch。新插件仍是 untrusted/disabled，需要在 TUI 里执行：
  #   /plugin trust <name> <hash>
  #   /plugin enable <name>
  # 内容不变时不会重建，已有 trust receipt 继续有效。
  # ---------------------------------------------------------------------------
  home.activation.codewhalePlugins =
    lib.hm.dag.entryAfter [ "writeBoundary" ]
      ''
        plugin_root="$HOME/.codewhale/plugins"
        run ${pkgs.coreutils}/bin/mkdir -p "$plugin_root"

        for src in ${pluginsDir}/*/; do
          [ -d "$src" ] || continue

          # 只处理带 Codewhale 支持的 manifest 的目录
          if [ ! -e "$src/plugin.json" ] \
            && [ ! -e "$src/plugin.toml" ] \
            && [ ! -e "$src/kimi.plugin.json" ] \
            && [ ! -e "$src/.claude-plugin/plugin.json" ]; then
            continue
          fi

          name="$(${pkgs.coreutils}/bin/basename "$src")"
          dst="$plugin_root/$name"

          # 内容一致就保持原样，避免每次 switch 都重建
          if [ -d "$dst" ] && ${pkgs.diffutils}/bin/diff -rq "$src" "$dst" >/dev/null 2>&1; then
            continue
          fi

          run ${pkgs.coreutils}/bin/rm -rf "$dst"
          run ${pkgs.coreutils}/bin/cp -r "$src" "$dst"
          run ${pkgs.coreutils}/bin/chmod -R u+w "$dst"
        done
      '';
}
