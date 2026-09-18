return {
  "mason-org/mason-lspconfig.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
  opts = {
    ensure_installed = (function()
      local list = {}
      for _, server in ipairs(require("config.servers")) do
        if server ~= "sqls" then
          list[#list + 1] = server
        end
      end
      return list
    end)(),
    automatic_enable = false,
  },
}
