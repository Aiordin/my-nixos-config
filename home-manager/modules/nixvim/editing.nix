# 代码编辑辅助：注释、自动配对、彩虹括号、Todo 高亮、surround 操作
{
  ...
}: {
  programs.nixvim.plugins = {
    # ---- 注释 ----
    comment.enable = true;

    # ---- 自动配对括号 / 引号 ----
    nvim-autopairs.enable = true;

    # ---- 彩虹括号 ----
    rainbow-delimiters.enable = true;

    # ---- surround 操作（mini.surround）----
    # sa + 范围 + 字符  → 添加包围（如 saiw" 给单词加双引号）
    # sd + 字符        → 删除包围
    # sr + 旧字符 + 新字符 → 替换包围
    # sfc / sf + 字符  → 查找并修改包围（f = forward）
    mini = {
      enable = true;
      modules.surround = { };
    };

    # ---- Todo 注释高亮 ----
    todo-comments = {
      enable = true;
      settings.keywords = {
        FIX.icon = " ";
        TODO.icon = " ";
        HACK.icon = " ";
        WARN.icon = " ";
        PERF.icon = " ";
        NOTE.icon = " ";
        TEST.icon = "⏽ ";
      };
    };
  };

  # mini.surround 使用 s 前缀（非 leader），which-key 会自动发现
  # 无需额外注册 which-key 组（避免与 <leader>s 窗格组冲突）
}
