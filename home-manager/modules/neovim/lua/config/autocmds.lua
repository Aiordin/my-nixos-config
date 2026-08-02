-- 自定义自动命令
-- LazyVim 默认 autocmds: https://www.lazyvim.org/configuration/general#autocommands
-- 此文件在 VeryLazy 事件时自动加载

local group = vim.api.nvim_create_augroup("UserAutocmds", { clear = true })

-- 示例：终端中禁用行号
-- vim.api.nvim_create_autocmd("TermOpen", {
--   group = group,
--   callback = function()
--     vim.opt_local.number = false
--     vim.opt_local.relativenumber = false
--   end,
-- })
