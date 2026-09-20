return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  init = function()
    -- 关掉内置 ftplugin 的 ]]/[[ 等映射，让位给下面的 textobjects move
    vim.g.no_plugin_maps = true
  end,
  config = function()
    require("nvim-treesitter-textobjects").setup({
      select = {
        lookahead = true, -- 光标不在对象内时自动向前找最近的对象
        selection_modes = {
          ["@function.outer"] = "V", -- 函数/类按行选
          ["@class.outer"] = "V",
        },
      },
      move = {
        set_jumps = true, -- 计入 jumplist，可用 <C-o> 回退
      },
    })

    local ts_select = require("nvim-treesitter-textobjects.select")
    local ts_move = require("nvim-treesitter-textobjects.move")
    local ts_swap = require("nvim-treesitter-textobjects.swap")

    -- select：am/im 函数、ac/ic 类、aa/ia 参数（x/o 模式）
    -- 注：官方新约定用 am/im 表示 function，避免与内置 af 混淆
    local select_maps = {
      ["am"] = "@function.outer",
      ["im"] = "@function.inner",
      ["ac"] = "@class.outer",
      ["ic"] = "@class.inner",
      ["aa"] = "@parameter.outer",
      ["ia"] = "@parameter.inner",
    }
    for lhs, query in pairs(select_maps) do
      vim.keymap.set({ "x", "o" }, lhs, function()
        ts_select.select_textobject(query, "textobjects")
      end, { desc = "TS textobject " .. query })
    end

    -- move：]m/[m 函数首、]M/[M 函数尾、]]/[[ 类首、][/[] 类尾
    -- 不启用 repeatable_move：;/, 重映射会撞 leader(,)
    local move_maps = {
      ["]m"] = { ts_move.goto_next_start, "@function.outer" },
      ["[m"] = { ts_move.goto_previous_start, "@function.outer" },
      ["]M"] = { ts_move.goto_next_end, "@function.outer" },
      ["[M"] = { ts_move.goto_previous_end, "@function.outer" },
      ["]]"] = { ts_move.goto_next_start, "@class.outer" },
      ["[["] = { ts_move.goto_previous_start, "@class.outer" },
      ["]["] = { ts_move.goto_next_end, "@class.outer" },
      ["[]"] = { ts_move.goto_previous_end, "@class.outer" },
    }
    for lhs, spec in pairs(move_maps) do
      vim.keymap.set({ "n", "x", "o" }, lhs, function()
        spec[1](spec[2], "textobjects")
      end, { desc = "TS move " .. spec[2] })
    end

    -- swap：与后/前一个参数交换位置
    vim.keymap.set("n", "<leader>a", function()
      ts_swap.swap_next("@parameter.inner")
    end, { desc = "Swap parameter with next" })
    vim.keymap.set("n", "<leader>A", function()
      ts_swap.swap_previous("@parameter.inner")
    end, { desc = "Swap parameter with previous" })
  end,
}
