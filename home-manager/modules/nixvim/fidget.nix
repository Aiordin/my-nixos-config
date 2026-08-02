# fidget.nvim — LSP 状态通知（轻量级进度提示）
# 在编辑器右下角显示 LSP 加载进度、诊断统计等
{
  ...
}: {
  programs.nixvim.plugins.fidget = {
    enable = true;

    settings = {
      # 进度轮询间隔（毫秒）
      progress.polling_rate = 0;

      # 通知配置
      notification = {
        poll_rate = 10; # Hz
        window.winblend = 0; # 不透明背景
      };

      # 进度显示
      progress = {
        display = {
          render_limit = 16; # 最多同时显示 16 个进度条
          done_ttl = 3; # 完成后保留 3 秒
        };
      };

      # LSP 服务器状态
      integration = {
        # 使用 nvim-tree/nvim-web-devicons 作为图标
        "nvim-tree/nvim-web-devicons" = true;
      };

      # 日志级别
      logger.level = "warn";
    };
  };
}
