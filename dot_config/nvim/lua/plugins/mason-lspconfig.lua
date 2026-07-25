return {
  "mason-org/mason-lspconfig.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
  opts = {
    ensure_installed = require("config.servers"),
    automatic_enable = false, -- enable 由 nvim-lspconfig.lua 统一调用 vim.lsp.enable()
  },
}
