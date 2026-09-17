-- 所有需要安装与启用的 LSP 服务器
-- mason-lspconfig (ensure_installed) 与 nvim-lspconfig (vim.lsp.enable) 共享此列表
return {
  "bashls",
  "eslint",
  "jsonls",
  "lua_ls",
  "basedpyright",
  "rust_analyzer",
  "ts_ls",
  "gopls",
  "marksman",
  "taplo",
  "yamlls",
}
