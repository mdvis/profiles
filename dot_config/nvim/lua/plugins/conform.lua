-- prettierd 冷启动慢（拉起 Node 守护进程），这些 ft 走异步 format_after_save，
-- 避免 format_on_save 同步阻塞保存（1200ms 超时上限内冷启动可能失败）；
-- 其余 ft 的 formatter 均为快速原生二进制，保留同步 format_on_save。
local slow_fts = {
  javascript = true,
  javascriptreact = true,
  typescript = true,
  typescriptreact = true,
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
      -- 慢 ft（prettier 家族）跳过同步保存，由 format_after_save 异步处理
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
      -- 异步执行，若 buffer 未被继续编辑，conform 会自动 :update 重写文件；
      -- 异步路径下 timeout_ms 不掐死 formatter，无需设置
      return { lsp_format = "fallback" }
    end,
  },
}
