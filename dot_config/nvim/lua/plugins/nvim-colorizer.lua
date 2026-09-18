return {
  "catgoose/nvim-colorizer.lua",
  event = "BufReadPre", -- Load when opening files
  cmd = {
    "ColorizerAttachToBuffer",
    "ColorizerDetachFromBuffer",
    "ColorizerReloadAllBuffers",
    "ColorizerToggle",
  },
  opts = {
    -- 只在会出现色值的文件类型启用，避免对日志等大文件做无意义的扫描
    filetypes = {
      "css",
      "scss",
      "less",
      "html",
      "vue",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "lua",
    },
    options = {
      parsers = {
        hex = { default = true }, -- #RGB, #RRGGBB, #RRGGBBAA
        names = { enable = true }, -- "Name" codes like Blue
        rgb = { enable = true }, -- CSS rgb() and rgba() functions
        hsl = { enable = true }, -- CSS hsl() and hsla() functions
        css = { enable = true }, -- Enable all CSS features
        css_fn = { enable = true }, -- Enable all CSS *functions*
      },
      display = {
        mode = "background", -- foreground | background | underline | virtualtext
      },
    },
  },
}
