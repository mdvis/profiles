return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    -- 需要安装的 parser 列表
    local ensure_installed = {
      "bash",
      "go",
      "gomod",
      "gosum",
      "gowork",
      "javascript",
      "jsdoc",
      "json",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "python",
      "regex",
      "rust",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
    }

    -- 异步安装缺失的 parser（不阻塞启动）
    local ts_config = require("nvim-treesitter.config")
    local installed = ts_config.get_installed()
    local missing = vim.tbl_filter(function(lang)
      return not vim.list_contains(installed, lang)
    end, ensure_installed)
    if #missing > 0 then
      require("nvim-treesitter.install").install(missing, { summary = true })
    end

    -- 启用 treesitter 高亮（Neovim 0.10+ 内建 vim.treesitter.start）
    -- runtime 仅对部分 filetype 自动启动，这里显式覆盖所有带 parser 的 filetype
    -- 注：vim.treesitter.start 只启用高亮，不启用 TS 缩进。
    -- 若需 TS 缩进，在 callback 中追加：vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
      end,
    })
  end,
}
