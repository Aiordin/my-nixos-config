# 代码编辑辅助：注释、自动配对、彩虹括号、Todo 高亮
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
}
