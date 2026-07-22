return {
  "echasnovski/mini.align",
  keys = { "ga", "gA" },
  config = function()
    require("mini.align").setup({
      mappings = {
        start = "gA", -- 开始对齐
        start_with_preview = "ga", -- 带预览的对齐
      },
    })
  end,
}
