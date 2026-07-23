return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      background = { light = "latte", dark = "mocha" },
      transparent_background = false,
      integrations = {
        native_lsp = { enabled = true },
        treesitter = true,
        telescope = { enabled = true },
        gitsigns = true,
        which_key = true,
        mason = true,
        trouble = true,
        render_markdown = true,
        flash = true,
        mini = { enabled = true, indentscope_color = "" },
      },
    })
    vim.cmd.colorscheme "catppuccin"
  end,
}
