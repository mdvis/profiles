local map = vim.keymap.set

map("n", "<leader><leader>t", "<cmd>SetTpl<cr>", { silent = true, desc = "Set template" })
map("n", "<leader><cr>", "<cmd>noh<cr>", { silent = true, desc = "Clear search highlight" })

map("n", "j", "v:count == 0 and 'gj' or 'j'", { expr = true, silent = true, desc = "Move down by visual line" })
map("n", "k", "v:count == 0 and 'gk' or 'k'", { expr = true, silent = true, desc = "Move up by visual line" })
map("n", "0", "^", { desc = "Go to first non-blank character" })
