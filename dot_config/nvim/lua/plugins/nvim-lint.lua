return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufNewFile", "BufWritePost", "InsertLeave" },
  config = function()
    local lint = require("lint")
    local function first_available(candidates)
      for _, item in ipairs(candidates) do
        local linter_name = item[1]
        local cmd = item[2]
        if vim.fn.executable(cmd) == 1 then
          return { linter_name }
        end
      end
      return {}
    end

    local preferred_by_ft = {
      go = { { "golangcilint", "golangci-lint" } },
      python = { { "ruff", "ruff" } },
      sh = { { "shellcheck", "shellcheck" } },
      bash = { { "shellcheck", "shellcheck" } },
      css = { { "stylelint", "stylelint" } },
      scss = { { "stylelint", "stylelint" } },
      less = { { "stylelint", "stylelint" } },
      sql = { { "sqlfluff", "sqlfluff" } },
      markdown = { { "markdownlint-cli2", "markdownlint-cli2" }, { "markdownlint", "markdownlint" } },
      yaml = { { "yamllint", "yamllint" } },
    }

    -- stylelint 只有在项目内装了本地依赖时才启用：配置与其 extends 的包都从文件所在目录解析，
    -- 否则会退到家目录的 .stylelintrc.json 并因缺 stylelint-config-standard 而每次保存报错
    local function project_stylelint(bufnr)
      local name = vim.api.nvim_buf_get_name(bufnr)
      local dir = name ~= "" and vim.fs.dirname(name) or vim.fn.getcwd()
      local node_modules = vim.fs.find("node_modules", { path = dir, upward = true, type = "directory" })[1]
      return node_modules ~= nil and vim.fn.filereadable(node_modules .. "/.bin/stylelint") == 1
    end
    local predicates = { stylelint = project_stylelint }

    local group = vim.api.nvim_create_augroup("nvim_lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = group,
      callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        local candidates = preferred_by_ft[vim.bo[bufnr].filetype]
        if not candidates then
          return
        end
        local linters = vim.tbl_filter(function(name)
          local predicate = predicates[name]
          return predicate == nil or predicate(bufnr)
        end, first_available(candidates))
        if #linters > 0 then
          lint.try_lint(linters)
        end
      end,
    })
  end,
}
