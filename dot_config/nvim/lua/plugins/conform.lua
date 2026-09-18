local slow_fts = {
  javascript = true,
  javascriptreact = true,
  typescript = true,
  typescriptreact = true,
  vue = true,
  json = true,
  jsonc = true,
  yaml = true,
  markdown = true,
  html = true,
  css = true,
  scss = true,
  less = true,
}

return {
  "stevearc/conform.nvim",
  cmd = "ConformInfo",
  event = { "BufWritePre" },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      desc = "Format buffer",
    },
  },
  opts = {
    formatters_by_ft = {
      go = { "goimports", "gofumpt" },
      rust = { "rustfmt" },
      python = { "ruff_format" },
      lua = { "stylua" },
      sh = { "shfmt" },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      javascriptreact = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      typescriptreact = { "prettierd", "prettier", stop_after_first = true },
      vue = { "prettierd", "prettier", stop_after_first = true },
      sql = { "sql_formatter" },
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
        options = { default_edition = "2024" },
      },
    },
    format_on_save = function(bufnr)
      if slow_fts[vim.bo[bufnr].filetype] then
        return
      end
      return {
        timeout_ms = 1200,
        lsp_format = "fallback",
        bufnr = bufnr,
      }
    end,
    format_after_save = function(bufnr)
      if not slow_fts[vim.bo[bufnr].filetype] then
        return
      end
      return { lsp_format = "fallback" }
    end,
  },
}
