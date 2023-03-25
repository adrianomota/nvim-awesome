local luasnip = require "luasnip"

local cmp = require "cmp"
cmp.setup {
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert {
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true },
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end, { "i", "s" }),
	},
	sources = { { name = "nvim_lsp" }, { name = "luasnip" } },
}

local null_ls = require "null-ls"
null_ls.setup {
	sources = {
		null_ls.builtins.diagnostics.eslint_d.with { extra_filetypes = { "astro" } },
		null_ls.builtins.formatting.autopep8,
		null_ls.builtins.formatting.eslint_d.with { extra_filetypes = { "astro" } },
		null_ls.builtins.formatting.gofmt,
		null_ls.builtins.formatting.prettierd,
		null_ls.builtins.formatting.rustfmt,
		null_ls.builtins.formatting.stylua,
	},
}

local lspconfig = require "lspconfig"
local actions = require('telescope.actions')
local builtin = require("telescope.builtin")
local fb_actions = require "telescope".extensions.file_browser.actions
local telescope = require "telescope"
local function telescope_buffer_dir()
  return vim.fn.expand('%:p:h')
end

telescope.setup {
	defaults = {
	  file_ignore_patterns = {
		".elixir_ls",
		-- all your ignore settings come here
		"**/node_modules/**",
	  },
	  mappings = {

		n = {
		  ["q"] = actions.close
		},
	  },
	},
	extensions = {
	  file_browser = {
		theme = "dropdown",
		-- disables netrw and use telescope-file-browser in its place
		hijack_netrw = true,
		mappings = {
		  -- your custom insert mode mappings
		  ["i"] = {
			["<C-w>"] = function() vim.cmd('normal vbd') end,
		  },
		  ["n"] = {
			-- your custom normal mode mappings
			["N"] = fb_actions.create,
			["h"] = fb_actions.goto_parent_dir,
			["/"] = function()
			  vim.cmd('startinsert')
			end
		  },
		},
	  },
	},
  }
telescope.load_extension "file_browser"
vim.keymap.set('n', '<C-P>',
  function()
    builtin.find_files({
      no_ignore = false,
      hidden = true
    })
  end)

vim.keymap.set('n', '<C-f>', function()
  builtin.live_grep()
end)

vim.keymap.set('n', '<C-B>', function()
  builtin.buffers()
end)

vim.keymap.set('n', ';t', function()
  builtin.help_tags()
end)

vim.keymap.set('n', ';;', function()
  builtin.resume()
end)

vim.keymap.set('n', ';e', function()
  builtin.diagnostics()
end)

vim.keymap.set("n", "<C-N>", function()
  telescope.extensions.file_browser.file_browser({
    path = "%:p:h",
    cwd = telescope_buffer_dir(),
    respect_gitignore = false,
    hidden = true,
    grouped = true,
    previewer = false,
    initial_mode = "normal",
    layout_config = { height = 40 }
  })
end)

require("nvim-treesitter.configs").setup {
	ensure_installed = {
		"astro",
		"bash",
		"cpp",
		"css",
		"go",
		"html",
		"lua",
		"make",
		"python",
		"rust",
		"tsx",
		"typescript",
		"yaml",
		"elixir",
		"eex",
		"c_sharp",
	},
	highlight = { enable = true },
}

require("rust-tools").setup {}

require("mason").setup {}

local servers = {
	"astro",
	"bashls",
	"clangd",
	"cssls",
	"gopls",
	"html",
	"pyright",
	"rust_analyzer",
	"lua_ls",
	"tailwindcss",
	"tsserver",
	"elixirls",
	"omnisharp",
	"clangd",
}

require("mason-lspconfig").setup {
	ensure_installed = servers,
	automatic_installation = true,
}

local lsp_formatting = function(bufnr)
	local deny_formatting = {
		"astro",
		"gopls",
		"html",
		"rust_analyzer",
		"lua_ls",
		"tsserver",
		"elixirls",
	    "omnisharp" }
	vim.lsp.buf.format {
		filter = function(client)
			for _, value in pairs(deny_formatting) do
				if client.name == value then
					return false
				end
			end
			return true
		end,
		bufnr = bufnr,
	}
end

local opts = {
	on_attach = function(client, bufnr)
		vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
		local opts = { buffer = bufnr }

		vim.keymap.set("n", "<Leader>h", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<Leader>i", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "<Leader>r", vim.lsp.buf.rename, opts)

		if client.supports_method "textDocument/formatting" then
			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

			vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					lsp_formatting(bufnr)
				end,
			})
		end
	end,
	capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
}

for _, server in pairs(servers) do
	if server == "lua_ls" then
		opts.settings = { Lua = { diagnostics = { globals = { "vim" } } } }
	end

	lspconfig[server].setup(opts)
end
