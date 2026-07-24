return {
  "echasnovski/mini.align",
  keys = {
    { "ga", desc = "Align (with preview)" },
    { "gA", desc = "Align (no preview)" },
  },
  config = function()
    require("mini.align").setup({
      mappings = {
        start = "gA",
        start_with_preview = "ga",
      },
    })
  end,
}
