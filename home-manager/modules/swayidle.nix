# ⚠️ 已停用（未在 home-manager/home.nix 中 import）
# 原因：Noctalia 自带空闲管理（锁屏 300s / 关屏 360s / 挂起 900s），
# 两套空闲守护会互相抢屏（swaylock 与 Noctalia 锁屏）。
# 如需恢复：在 home.nix 重新 import 本文件，并把
# modules/programs.nix 里的 services.swayidle.enable 改回 true。
{ pkgs,... }:
{
    services.swayidle = {
        timeouts = [
            {
                # 10分钟（600秒）：自动锁屏
                timeout = 600;
                command = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
            }
            {
                # 30分钟（1800秒）：关闭屏幕
                timeout = 1800;
                command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
                resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
            }
            {
                # 40分钟（2400秒）：系统彻底进入休眠
                timeout = 2400;
                command = "systemctl suspend";
            }
        ];

        # 休眠系统先锁屏
        events = {
            before-sleep = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
            lock = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
        };
    };
}
