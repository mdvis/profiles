return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    view_options = {
      show_hidden = true,
      is_hidden_file = function(name, bufnr)
        -- Don't mark files as "hidden" since we want to show dotfiles
        return false
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
          if pattern:match("%*") then
            -- Handle wildcard patterns like *.egg-info
            local regex = pattern:gsub("%.", "%%."):gsub("%*", ".*")
            if name:match("^" .. regex .. "$") then
              return true
            end
          else
            if name == pattern then
              return true
            end
          end
        end
        return false
      end,
    },
  },
  -- Optional dependencies
  dependencies = { { "nvim-tree/nvim-web-devicons", opts = {} } },
  keys = {
    { "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
  },
}
