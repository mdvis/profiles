return {
  "mrjones2014/smart-splits.nvim",
  lazy = false, -- multiplexer integration 需要常驻；若不用 tmux/zellij/wezterm 可改为 keys 触发
  opts = {
    -- Ignored filetypes (only while resizing)
    ignored_filetypes = { "oil" },
    resize = {
      -- Default resize amount (multiplied by v:count1)
      amount = 3,
    },
    move = {
      -- Behavior at edge: 'wrap' | 'split' | 'stop'
      at_edge = "wrap",
      -- Keep cursor on the same screen row when moving horizontally
      same_row = false,
    },
    swap = {
      -- Follow the buffer into its new window
      move_cursor = false,
    },
    -- Multiplexer integration (auto-detected: tmux, zellij, wezterm, kitty)
    -- via `mux.backend`; zoom handling now lives in the backend plugin.
  },
  keys = {
    -- Resizing splits
    {
      "<A-h>",
      function()
        require("smart-splits").resize_left()
      end,
      desc = "Resize split left",
    },
    {
      "<A-j>",
      function()
        require("smart-splits").resize_down()
      end,
      desc = "Resize split down",
    },
    {
      "<A-k>",
      function()
        require("smart-splits").resize_up()
      end,
      desc = "Resize split up",
    },
    {
      "<A-l>",
      function()
        require("smart-splits").resize_right()
      end,
      desc = "Resize split right",
    },

    -- Moving between splits
    {
      "<C-h>",
      function()
        require("smart-splits").move_cursor_left()
      end,
      desc = "Move to left split",
    },
    {
      "<C-j>",
      function()
        require("smart-splits").move_cursor_down()
      end,
      desc = "Move to below split",
    },
    {
      "<C-k>",
      function()
        require("smart-splits").move_cursor_up()
      end,
      desc = "Move to above split",
    },
    {
      "<C-l>",
      function()
        vim.cmd("nohlsearch")
        vim.cmd("diffupdate")
        vim.cmd([[execute "normal! \<C-l>"]])
        require("smart-splits").move_cursor_right()
      end,
      desc = "Move to right split (also clears hl/diff/redraw)",
    },
    {
      "<C-\\>",
      function()
        require("smart-splits").move_cursor_previous()
      end,
      desc = "Move to previous split",
    },

    -- Swapping buffers between windows
    {
      "<leader>wh",
      function()
        require("smart-splits").swap_buf_left()
      end,
      desc = "Swap buffer left",
    },
    {
      "<leader>wj",
      function()
        require("smart-splits").swap_buf_down()
      end,
      desc = "Swap buffer down",
    },
    {
      "<leader>wk",
      function()
        require("smart-splits").swap_buf_up()
      end,
      desc = "Swap buffer up",
    },
    {
      "<leader>wl",
      function()
        require("smart-splits").swap_buf_right()
      end,
      desc = "Swap buffer right",
    },
  },
}
