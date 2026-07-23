return {
  "saghen/blink.cmp",
  version = "v1.*",
  dependencies = { "rafamadriz/friendly-snippets" },
  opts = {
    keymap = { preset = "super-tab" },
    appearance = { nerd_font_variant = "mono" },
    snippets = { preset = "default" },
    completion = {
      trigger = {
        show_on_trigger_character = true,
        show_on_keyword = true,
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
      accept = {
        auto_brackets = {
          enabled = true,
        },
      },
    },
    sources = { default = { "lsp", "path", "snippets", "buffer" } },
    signature = { enabled = true }, -- 输入函数参数时自动弹出签名帮助
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
}
