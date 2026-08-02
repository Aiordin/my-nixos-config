-- 自定义快捷键（追加/覆盖 LazyVim 默认）
-- LazyVim 默认 keymaps: https://www.lazyvim.org/keymaps
-- 此文件在 VeryLazy 事件时自动加载

local map = vim.keymap.set

-- 智能关闭窗口：最后一个窗口时退出，否则关闭当前窗口
map("n", "<leader>q", function()
  local wins = vim.fn.winnr("$")
  -- 排除浮动窗口
  local normal_wins = 0
  for i = 1, wins do
    local config = vim.api.nvim_win_get_config(vim.fn.win_getid(i))
    if not config.relative or config.relative == "" then
      normal_wins = normal_wins + 1
    end
  end
  if normal_wins <= 1 then
    vim.cmd("quit")
  else
    vim.cmd("close")
  end
end, { desc = "Smart close window" })
