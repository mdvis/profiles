return {
  "stevearc/conform.nvim",
  cmd = "ConformInfo",
  event = { "BufWritePre" },
  keys = {
    { "<leader>f", function() require("conform").format({ async = true, lsp_format = "fallback" }) end, desc = "Format buffer" },
  },
  opts = {
    formatters_by_ft = {
      go = { "goimports", "gofumpt" },
      rust = { "rustfmt" },
      python = { "ruff_format" }, -- 使用 ruff_format（更快），如需 black 可替换
      lua = { "stylua" },
      sh = { "shfmt" },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      javascriptreact = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      typescriptreact = { "prettierd", "prettier", stop_after_first = true },
      json = { "prettierd", "prettier", stop_after_first = true },
      jsonc = { "prettierd", "prettier", stop_after_first = true },
      yaml = { "prettierd", "prettier", stop_after_first = true },
      markdown = { "prettierd", "prettier", stop_after_first = true },
      html = { "prettierd", "prettier", stop_after_first = true },
      css = { "prettierd", "prettier", stop_after_first = true },
      scss = { "prettierd", "prettier", stop_after_first = true },
      less = { "prettierd", "prettier", stop_after_first = true },
      toml = { "taplo" },
    },
    formatters = {
      rustfmt = {
        args = { "--edition=2021" },
      },
    },
    format_on_save = function(bufnr)
      return {
        timeout_ms = 1200,
        lsp_format = "fallback",
        bufnr = bufnr,
      }
    end,
  },
}
