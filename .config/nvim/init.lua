vim.g.mapleader = " " -- map leader key to spacebar
vim.o.softtabstop = 4 -- recommended by nvim docs to set tab width
vim.o.shiftwidth = 4 -- width for auto indents
vim.o.number = true -- enable line numbers
vim.o.cursorline = true -- enable highlight of the line that have cursor on
vim.cmd("set clipboard=unnamedplus") -- enable use of sytem clipboard
vim.cmd("syntax enable") -- enable syntax highlighting
vim.cmd("set cc=80") -- set an 80 column border

local vim = vim
local Plug = vim.fn["plug#"]

vim.call("plug#begin")
Plug("voldikss/vim-floaterm")
Plug("simrat39/rust-tools.nvim")
Plug("neovim/nvim-lspconfig")
Plug("williamboman/mason.nvim")
Plug("williamboman/mason-lspconfig.nvim")
Plug("stevearc/conform.nvim")
Plug("nvim-tree/nvim-web-devicons")
Plug("nvim-lualine/lualine.nvim")
--[[ requires = nvim-web-devicons -- for icons ]]
Plug("nvim-lua/plenary.nvim")
Plug("nvim-treesitter/nvim-treesitter", { ["do"] = ":TSUpdate" })
Plug("nvim-telescope/telescope.nvim", { ["tag"] = "0.1.5" })
--[[ requires = plenary.nvim, nvim-treesitter ]]
Plug("folke/which-key.nvim")
Plug("catppuccin/nvim", { ["as"] = "catppuccin" })

vim.call("plug#end")

-- Color schemes should be loaded after plug#end().
-- We prepend it with 'silent!' to ignore errors when it's not yet installed.
vim.cmd("silent! colorscheme catppuccin-mocha")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

require("telescope").setup({
	defaults = {
		-- configure to use ripgrep
		vimgrep_arguments = {
			"rg",
			"--follow", -- Follow symbolic links
			"--hidden", -- Search for hidden files
			"--no-heading", -- Don't group matches by each file
			"--with-filename", -- Print the file path with the matched lines
			"--line-number", -- Show line numbers
			"--column", -- Show column numbers
			"--smart-case", -- Smart case search

			-- Exclude some patterns from search
			"--glob=!**/.git/*",
			"--glob=!**/.idea/*",
			"--glob=!**/.vscode/*",
			"--glob=!**/build/*",
			"--glob=!**/dist/*",
			"--glob=!**/yarn.lock",
			"--glob=!**/package-lock.json",
		},

		...,
	},
	pickers = {
		find_files = {
			hidden = true,
			-- needed to exclude some files & dirs from general search
			-- when not included or specified in .gitignore
			find_command = {
				"rg",
				"--files",
				"--hidden",
				"--glob=!**/.git/*",
				"--glob=!**/.idea/*",
				"--glob=!**/.vscode/*",
				"--glob=!**/build/*",
				"--glob=!**/dist/*",
				"--glob=!**/yarn.lock",
				"--glob=!**/package-lock.json",
			},
		},
	},
})

require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "auto",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = false,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { "filename" },
		lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {},
})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		-- You can customize some of the format options for the filetype (:help conform.format)
		rust = { "rustfmt" },
	},
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

-- Mason Setup
require("mason").setup({
	ui = {
		icons = {
			package_installed = "",
			package_pending = "",
			package_uninstalled = "",
		},
	},
})
require("mason-lspconfig").setup()

local rt = require("rust-tools")

rt.setup({
	server = {
		on_attach = function(_, bufnr)
			-- Hover actions
			vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
			-- Code action groups
			vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
		end,
	},
})

-- LSP Diagnostics Options Setup
local sign = function(opts)
	vim.fn.sign_define(opts.name, {
		texthl = opts.name,
		text = opts.text,
		numhl = "",
	})
end

sign({ name = "DiagnosticSignError", text = "0"}) --"" })
sign({ name = "DiagnosticSignWarn", text = "2" }) --"" })
sign({ name = "DiagnosticSignHint", text = "1" }) --"" })
sign({ name = "DiagnosticSignInfo", text = "3" }) --"" })

vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	update_in_insert = true,
	underline = true,
	severity_sort = false,
	float = {
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
})

vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])
