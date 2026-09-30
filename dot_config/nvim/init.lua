vim.g.mapleader = ","
vim.g.maplocalleader = ","

local init_file = debug.getinfo(1, "S").source:sub(2)
local config_dir = vim.fn.fnamemodify(init_file, ":p:h")
vim.opt.rtp:prepend(config_dir)

require("config.options")
require("config.autocmds")
require("config.keymaps")
require("config.lazy")
