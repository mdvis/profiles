return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    skip_confirm_for_simple_edits = true,
    float = {
      padding = 2,
      max_width = 0.8,
      max_height = 0.8,
      border = "rounded",
      win_options = {
        winblend = 0,
      },
    },
    view_options = {
      show_hidden = true,
      is_hidden_file = function(name, bufnr)
        -- Mark dotfiles as hidden so they get different styling
        return vim.startswith(name, ".")
      end,
      is_always_hidden = function(name, bufnr)
        local always_hidden = {
          -- Version control
          ".git",
          ".svn",
          -- macOS
          ".DS_Store",
          -- JavaScript/Node
          "node_modules",
          ".npm",
          ".yarn",
          -- Python
          "__pycache__",
          ".pytest_cache",
          ".mypy_cache",
          ".ruff_cache",
          ".venv",
          "venv",
          ".tox",
          ".eggs",
          ".ipynb_checkpoints",
          -- Java
          "target",
          ".gradle",
          ".mvn",
          "build",
          "out",
          ".idea",
          -- Rust
          "Cargo.lock",
          -- Go
          "vendor",
          -- General build artifacts
          "dist",
          ".cache",
          ".turbo",
          ".next",
          ".nuxt",
          ".output",
        }
        
        for _, pattern in ipairs(always_hidden) do
          if name == pattern then
            return true
          end
        end
        return false
      end,
    },
  },
  -- Optional dependencies
  dependencies = { { "nvim-tree/nvim-web-devicons", opts = {} } },
  keys = {
    { "-", "<CMD>Oil --float<CR>", desc = "Open parent directory (float)" },
  },
}
