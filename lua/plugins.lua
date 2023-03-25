local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  print("Installing packer close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
})

packer.startup(function(use)
  use "wbthomason/packer.nvim"

	use "andweeb/presence.nvim"
	use { "catppuccin/nvim", as = "catppuccin" }
	use "hrsh7th/cmp-nvim-lsp"
	use "hrsh7th/nvim-cmp"
	use "jose-elias-alvarez/null-ls.nvim"
	use "kyazdani42/nvim-web-devicons"
	use "L3MON4D3/LuaSnip"
	use "lewis6991/gitsigns.nvim"
	use "neovim/nvim-lspconfig"
	use "nvim-lua/plenary.nvim"
	use "nvim-lualine/lualine.nvim"
	use "nvim-telescope/telescope.nvim"
	use "nvim-telescope/telescope-file-browser.nvim"
	use "nvim-treesitter/nvim-treesitter"
	use "onsails/lspkind-nvim"
	use "romainl/vim-cool"
	use "ryanoasis/vim-devicons"
	use "saadparwaiz1/cmp_luasnip"
	use "simrat39/rust-tools.nvim"
	use "tpope/vim-commentary"
	use "williamboman/mason.nvim"
	use "williamboman/mason-lspconfig.nvim"
	use "windwp/nvim-autopairs"
	use "https://git.sr.ht/~whynothugo/lsp_lines.nvim"
end)
