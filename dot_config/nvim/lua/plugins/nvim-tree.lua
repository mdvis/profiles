return {
  "nvim-tree/nvim-tree.lua",
  cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
  keys = {
    { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer (NvimTree)" },
    { "<leader>ge", "<cmd>NvimTreeFindFile<cr>", desc = "Find file in NvimTree" },
  },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    -- 与 oil 共存：不禁用 netrw、不 hijack
    disable_netrw = false,
    hijack_netrw = false,
    hijack_cursor = false,
    view = {
      width = 30,
      side = "left",
      number = false,
      relativenumber = false,
    },
    filters = {
      dotfiles = false,
      custom = {
        ".git",
        "node_modules",
        ".venv",
        "venv",
        "__pycache__",
        ".mypy_cache",
        ".ruff_cache",
        "target",
        "dist",
        ".next",
        ".nuxt",
      },
    },
    actions = {
      open_file = {
        quit_on_open = false,
        resize_window = true,
      },
    },
    renderer = {
      group_empty = true,
      highlight_git = true,
      icons = {
        show = { git = true, folder = true, file = true, folder_arrow = true },
      },
    },
    git = { enable = true, ignore = false },
  },
}
