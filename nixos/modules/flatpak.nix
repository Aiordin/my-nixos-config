{ pkgs, ... }:
{
  # nix-flatpak provides services.flatpak.overrides.settings for declarative
  # Flatpak permission management. This replaces the old environment.etc
  # approach which wrote to /etc/flatpak/overrides/ — a path Flatpak never
  # reads (it only reads /var/lib/flatpak/overrides/ for system overrides).
  services.flatpak.overrides.settings = {
    "com.qq.QQ" = {
      # QQ 实际以 XWayland/X11 模式运行（niri 会话 XDG_SESSION_TYPE=tty，QQ
      # 启动脚本不会加 --ozone-platform=wayland）。X11 模式下 Chromium 自行用
      # xcursor 库加载光标主题：
      #  1. 沙箱内必须能看到主题文件。Bibata-Modern-Ice 由 home-manager 以
      #     symlink 形式放入 ~/.icons，目标在 /nix/store —— 因此授权三个路径。
      #  2. 必须把 XCURSOR_THEME/SIZE 传入沙箱，否则回退默认光标。
      Context = {
        filesystems = [
          "/nix/store:ro"
          "~/.icons:ro"
          "~/.local/share/icons:ro"
        ];
      };
      # 输入法：QQ 在 X11 模式下走 fcitx5。GTK_IM_MODULE=fcitx 让 Electron 走
      # GTK IM module（runtime 25.08 自带 im-fcitx5.so），而非不可靠的 XIM；
      # 下方 Session Bus Policy 授权沙箱经 dbus 连接宿主 fcitx5 守护进程。
      Environment = {
        XCURSOR_THEME = "Bibata-Modern-Ice";
        XCURSOR_SIZE = "24";
        XMODIFIERS = "@im=fcitx";
        GTK_IM_MODULE = "fcitx";
        QT_IM_MODULE = "fcitx";
      };
      "Session Bus Policy"."org.fcitx.Fcitx5" = "talk";
    };
    "com.tencent.WeChat".Context = {
      # Keys are always plural: filesystems, sockets.
      # nix-flatpak accepts Nix lists and converts to semicolon-separated format.
      filesystems = [
        "~/Downloads"
        "~/Documents"
        "~/Pictures"
        "~/Desktop"
      ];
      sockets = [
        "x11"
        "wayland"
      ];
    };
  };

  # QQ 热更新守卫。
  #
  # 背景：腾讯通过 QQ 应用内热更新下发小版本（如 3.2.32-52194），该版本在
  # 本机（niri + Wayland）启动后约 1–2 分钟内以 SIGTRAP 崩溃（journal 多次
  # coredump），而 flatpak 包自带的 3.2.32-51802 正常。修复方式是回退
  # ~/.var/app/com.qq.QQ/config/QQ/versions/config.json 的 curVersion 到
  # baseVersion，并把坏版本记入 onErrorVersions，同时清理热更残留文件。
  #
  # 此服务在每次图形登录（default.target）时执行一次同样的回退：若当前
  # curVersion 命中下方 badVersions 列表（可在声明式配置里直接追加新版本号），
  # 则原子回退并清理。未来腾讯发布修复版热更时，将其从列表移除即可放行。
#   systemd.user.services.qq-hotupdate-guard = {
#     description = "Revert QQ hot-update to the known-good base version";
#     wantedBy = [ "default.target" ];
#     serviceConfig = {
#       Type = "oneshot";
#       ExecStart = "${pkgs.writeShellScript "qq-hotupdate-guard" ''
#         set -eu
#         versions="$HOME/.var/app/com.qq.QQ/config/QQ/versions"
#         config="$versions/config.json"
#         [ -f "$config" ] || exit 0
#
#         # 已知崩溃的热更版本（2026-08-12 实测 SIGTRAP）。新坏版本直接加进此列表。
#         badVersions="3.2.32-52074 3.2.32-52194"
#
#         cur="$(${pkgs.jq}/bin/jq -r '.curVersion // empty' "$config" 2>/dev/null)" || exit 0
#         case " $badVersions " in
#           *" $cur "*) ;;
#           *) exit 0 ;;
#         esac
#
#         base="$(${pkgs.jq}/bin/jq -r '.baseVersion // empty' "$config" 2>/dev/null)" || exit 0
#         [ -n "$base" ] || exit 0
#
#         # 原子回退：curVersion -> base，坏版本记入 onErrorVersions 并清空待装状态
#         ${pkgs.jq}/bin/jq -c \
#           --arg base "$base" \
#           --arg cur "$cur" \
#           '.curVersion = $base
#            | .prevVersion = $cur
#            | .onErrorVersions = ((.onErrorVersions + [ $cur ]) | unique)
#            | .readyVersion = ""
#            | .readyInstaller = ""' \
#           "$config" > "$config.guard.tmp" \
#           && mv "$config.guard.tmp" "$config"
#
#         # 清理坏版本的残留目录与压缩包
#         rm -rf "$versions/$cur" "$versions/$cur.zip" "$versions/$cur.zip.zip"
#       ''}";
#     };
#   };
}
