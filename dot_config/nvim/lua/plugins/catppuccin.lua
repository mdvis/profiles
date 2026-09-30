return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      background = { light = "latte", dark = "mocha" },
      transparent_background = false,
      auto_integrations = false,
      integrations = {
        treesitter = true,
        gitsigns = true,
        which_key = true,
        mason = true,
        trouble = true,
        flash = true,
        mini = { enabled = true },
        fidget = true,
        ibl = { enabled = true },
        nvim_surround = true,
        oil = true,
        blink_cmp = true,
        fzf = true,
        nvimtree = true,
        indent_blankline = { enabled = true },
        lsp_trouble = { enabled = true },
      },
    })
    vim.cmd.colorscheme("catppuccin")
  end,
}
