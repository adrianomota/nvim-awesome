vim.g.mapleader = " "

vim.keymap.set('n', '<C-s>', ':w<CR>')

vim.keymap.set('n', 'te', ':tabedit')

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

vim.keymap.set("n", "<Leader>w", "<C-w>k")
vim.keymap.set("n", "<Leader>a", "<C-w>h")
vim.keymap.set("n", "<Leader>s", "<C-w>j")
vim.keymap.set("n", "<Leader>d", "<C-w>l")

vim.keymap.set("n", "<Leader>j", ":bprevious<CR>", { silent = true })
vim.keymap.set("n", "<Leader>k", ":bnext<CR>", { silent = true })
vim.keymap.set("n", "<Leader>q", ":bprevious<CR>:bdelete #<CR>", { silent = true })

vim.keymap.set("n", "<Leader>y", ":%y<CR>")

vim.keymap.set("n", "k", "gk", { silent = true })
vim.keymap.set("n", "j", "gj", { silent = true })

vim.keymap.set("n", "<Leader>l", ":vsplit term://zsh <CR>", { silent = true })
vim.keymap.set("t", "<Leader><Esc>", "<C-\\><C-n>", { silent = true })

vim.keymap.set("n", "<Leader>v", ":edit ~/.config/nvim/init.lua<CR>", { silent = true })
vim.keymap.set("n", "<Leader>o", ":DashboardNewFile<CR>", { silent = true })

vim.keymap.set("n", "<C-p>", require("telescope.builtin").find_files)
vim.keymap.set("n", "<C-f>", require("telescope.builtin").live_grep)
vim.keymap.set("n", "<C-b>", require("telescope.builtin").buffers)
vim.keymap.set("n", "<C-t>", require("telescope.builtin").treesitter)
vim.keymap.set("n", "<C-n>", require("telescope").extensions.file_browser.file_browser)

vim.keymap.set({ "n", "v" }, "<Leader>c", ":Commentary<CR>", { silent = true })
