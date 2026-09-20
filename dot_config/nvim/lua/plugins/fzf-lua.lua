return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<C-p>", "<cmd>FzfLua files<cr>", desc = "Find Files" },
    { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find Files" },
    { "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Live Grep" },
    { "<leader>fh", "<cmd>FzfLua help_tags<cr>", desc = "Help Tags" },
    { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },
    { "<leader>fo", "<cmd>FzfLua oldfiles<cr>", desc = "Old Files" },
  },
  opts = {
    -- 跟随 colorscheme（catppuccin）着色
    fzf_colors = true,
    -- 与原 telescope 配置一致：忽略构建产物与锁文件
    file_ignore_patterns = { "node_modules", "%.lock", "%.git/", "dist", ".venv" },
    -- fzf-lua 的 files 默认已带 --hidden，显式写出以保持与旧行为一致
    files = { hidden = true },
    fzf_opts = {
      ["--prompt"] = "🔍 ",
      ["--pointer"] = "➤",
    },
  },
}
