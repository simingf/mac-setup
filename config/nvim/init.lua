-- ========================================================================== --
-- ==                           EDITOR SETTINGS                            == --
-- ========================================================================== --

-- enable line numbers
vim.opt.number = true
vim.opt.relativenumber = true
-- highlight current line
vim.opt.cursorline = false
-- enable mouse for all modes
vim.opt.mouse = 'a'
-- include both lower and upper case for search
vim.opt.ignorecase = true
-- ignore upper case letters unless the search includes upper case letters
vim.opt.smartcase = true
-- disable highlighting the result of the most recent search all the time
vim.opt.hlsearch = false
-- line wrapping
vim.opt.wrap = true
-- preserve indentation when line wrapping
vim.opt.breakindent = true
-- set how many spaces a tab is
vim.opt.tabstop = 2
-- set how many spaces << and >> indent by
vim.opt.shiftwidth = 2
-- enable converting a tab into spaces
vim.opt.expandtab = true
-- disable showing current mode since lualine shows
vim.opt.showmode = false
-- enable hexademical colors instead of only 256 colors
vim.opt.termguicolors = true
-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- ========================================================================== --
-- ==                           KEY BINDINGS                               == --
-- ========================================================================== --

-- set the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- copy
vim.keymap.set({ 'n', 'x' }, 'gy', '"+y')
-- paste
vim.keymap.set({ 'n', 'x' }, 'gp', '"+p')
-- prevent x or X from modifying the internal register
vim.keymap.set({ 'n', 'x' }, 'x', '"_x')
vim.keymap.set({ 'n', 'x' }, 'X', '"_d')
-- select all text in current buffer
vim.keymap.set('n', '<leader>a', ':keepjumps normal! ggVG<cr>')
-- swap windows
vim.api.nvim_set_keymap('n', '<Leader>w', '<C-w>', { noremap = true, silent = true })
-- format code
vim.keymap.set('v', '<Leader>bf', vim.lsp.buf.format, { noremap = true, silent = true })

-- ========================================================================== --
-- ==                           DIAGNOSTICS                                == --
-- ========================================================================== --

-- change diagnostic icons
local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end

sign({ name = 'DiagnosticSignError', text = '' })
sign({ name = 'DiagnosticSignWarn', text = '' })
sign({ name = 'DiagnosticSignHint', text = '' })
sign({ name = 'DiagnosticSignInfo', text = '' })

-- configure diagnostic options
vim.diagnostic.config({
  -- Show diagnostic message using virtual text.
  virtual_text = false,
  -- Show a sign next to the line with a diagnostic.
  signs = true,
  -- Update diagnostics while editing in insert mode.
  update_in_insert = false,
  -- Use an underline to show a diagnostic location.
  underline = true,
  -- Order diagnostics by severity.
  severity_sort = true,
  -- Show diagnostic messages in floating windows.
  float = {
    border = 'rounded',
    source = 'always',
  },
})

-- ========================================================================== --
-- ==                               PLUGINS                                == --
-- ========================================================================== --

-- setup code from documentation --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system(
    { "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", -- latest stable release
      lazypath })
end
vim.opt.rtp:prepend(lazypath)
-- setup code from documentation --

require("lazy").setup({
  -- dependencies
  { 'nvim-lua/plenary.nvim' },
  { 'kyazdani42/nvim-web-devicons' },
  -- theme
  -- { 'ellisonleao/gruvbox.nvim' },
  { "catppuccin/nvim" },
  -- editor ui
  { 'declancm/cinnamon.nvim' },
  { 'nvim-lualine/lualine.nvim' },
  { 'akinsho/bufferline.nvim' },
  { 'echasnovski/mini.bufremove' },
  { "lukas-reineke/indent-blankline.nvim" },
  { 'echasnovski/mini.cursorword' },
  -- editor utilities
  { 'nvim-treesitter/nvim-treesitter' },
  { 'nvim-treesitter/nvim-treesitter-textobjects' },
  { 'echasnovski/mini.comment' },
  { 'tpope/vim-surround' },
  -- file system
  { 'kyazdani42/nvim-tree.lua' },
  { 'nvim-telescope/telescope.nvim' },
  { 'nvim-telescope/telescope-fzf-native.nvim',   build = 'make' },
  -- mason
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },
  -- lsp
  { 'neovim/nvim-lspconfig' },
  -- formatter
  { 'stevearc/conform.nvim' },
  -- cmp (autocompletion)
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-cmdline' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  -- snippets
  { 'L3MON4D3/LuaSnip' },
  { 'saadparwaiz1/cmp_luasnip' },
  { 'rafamadriz/friendly-snippets' },
  -- copilot
  { 'zbirenbaum/copilot.lua' },
  { 'zbirenbaum/copilot-cmp' },
})

-- ========================================================================== --
-- ==                         CONFIGURATION                                == --
-- ========================================================================== --

-- gruvbox setup
-- vim.o.background = "dark"
-- require("gruvbox").setup({
--   contrast = "hard", -- can be "hard", "soft" or empty string
--   transparent_mode = true,
-- })
-- vim.cmd("colorscheme gruvbox")

-- catppuccin setup
require("catppuccin").setup({
    flavour = "mocha", -- latte, frappe, macchiato, mocha
    transparent_background = true, -- disables setting the background color.
    show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
    integrations = {
        cmp = true,
        gitsigns = false,
        nvimtree = true,
        treesitter = true,
        notify = false,
        mini = {
            enabled = true,
            indentscope_color = "",
        },
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
})
vim.cmd.colorscheme "catppuccin"

require('cinnamon').setup {
  default_keymaps = true,
  extra_keymaps = true,
  extended_keymaps = true,
  override_keymaps = true,
  always_scroll = true,
  max_length = 500,
  scroll_limit = 200,
}

-- lualine (better status line at the bottom)
-- See :help lualine.txt
require('lualine').setup({
  options = {
    theme = 'catppuccin',
    icons_enabled = true,
    section_separators = '',
    component_separators = '|'
  },
})

-- bufferline (shows open files as tabs at top)
require('bufferline').setup({
  options = {
    -- one tab per file
    mode = 'buffers',
    offsets = {
      { filetype = 'NvimTree' }
    },
  },
  highlights = {
    buffer_selected = {
      italic = false
    },
    indicator_selected = {
      fg = { attribute = 'fg', highlight = 'Function' },
      italic = false
    }
  }
})

-- swap tabs
vim.keymap.set('n', '<leader>bh', ':bprev<cr>')
vim.keymap.set('n', '<leader>bl', ':bnext<cr>')

-- close buffer without closing window
require('mini.bufremove').setup({})
vim.keymap.set('n', '<leader>bc', '<cmd>lua pcall(MiniBufremove.delete)<cr>')

-- indent guides
require('ibl').setup({
  enabled = true,
  scope = {
    enabled = true
  },
  indent = {
    char = '▏'
  }
})

-- underlines all words that are the same as word under cursor
require('mini.cursorword').setup({})

-- treesitter (creates syntax tree for various languages)
-- See :help nvim-treesitter-modules
require("nvim-treesitter.install").prefer_git = true
require('nvim-treesitter.configs').setup({
  highlight = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      }
    },
  },
  ensure_installed = {
    'vim', 'vimdoc', 'lua', 'bash', 'python', 'c', 'cpp', 'javascript', 'typescript', 'json', 'latex'
  },
})

-- use gcc to comment a line
require('mini.comment').setup({})

-- nvim-tree (file explorer)
require('nvim-tree').setup({
  view = {
    width = 25,
  },
  hijack_cursor = false,
  on_attach = function(bufnr)
    local bufmap = function(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = bufnr, desc = desc })
    end

    -- See :help nvim-tree.api
    local api = require('nvim-tree.api')
    bufmap('<cr>', api.node.open.edit, 'Expand folder or go to file')
    bufmap('cd', api.tree.change_root_to_node, 'Set current directory as root')
    bufmap('..', api.node.navigate.parent, 'Move to parent directory')
    bufmap('hh', api.tree.toggle_hidden_filter, 'Toggle hidden files')
  end
})
vim.cmd[[hi NvimTreeNormal guibg=NONE ctermbg=NONE]]

vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<cr>')

-- telescope (search / filter files)
-- See :help telescope.builtin
-- search open files
vim.keymap.set('n', '<leader>fo', '<cmd>Telescope buffers<cr>')
-- search recently opened files
vim.keymap.set('n', '<leader>fr', '<cmd>Telescope oldfiles<cr>')
-- search files in current directory
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
-- grep for a pattern in current directory
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>')
-- search diagnostic messages
vim.keymap.set('n', '<leader>fd', '<cmd>Telescope diagnostics<cr>')
-- fzf for a pattern in the current file
vim.keymap.set('n', '<leader><space>', '<cmd>Telescope current_buffer_fuzzy_find<cr>')

-- lsp (language server)
require('mason').setup()
require('mason-lspconfig').setup()
require("mason-lspconfig").setup_handlers {
  function(server_name) -- default handler (optional)
    require("lspconfig")[server_name].setup {
      capabilities = require('cmp_nvim_lsp').default_capabilities()
    }
  end,
}

local lspconfig = require('lspconfig')

-- lua lsp setup to fix undefined global vim error
lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
})

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function()
    local bufmap = function(mode, lhs, rhs)
      local opts = { buffer = true }
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- Displays hover information about the symbol under the cursor
    bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')

    -- Jump to the definition
    bufmap('n', '<leader>def', '<cmd>lua vim.lsp.buf.definition()<cr>')

    -- Jump to declaration
    bufmap('n', '<leader>dec', '<cmd>lua vim.lsp.buf.declaration()<cr>')

    -- Lists all the implementations for the symbol under the cursor
    bufmap('n', '<leader>imp', '<cmd>lua vim.lsp.buf.implementation()<cr>')

    -- Jumps to the definition of the type symbol
    bufmap('n', '<leader>tdef', '<cmd>lua vim.lsp.buf.type_definition()<cr>')

    -- Lists all the references
    bufmap('n', '<leader>ref', '<cmd>lua vim.lsp.buf.references()<cr>')

    -- Displays a function's signature information
    bufmap('n', '<leader>sig', '<cmd>lua vim.lsp.buf.signature_help()<cr>')

    -- Renames all references to the symbol under the cursor
    bufmap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>')

    -- Selects a code action available at the current cursor position
    bufmap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>')

    -- Show diagnostics in a floating window
    bufmap('n', '<leader>dd', '<cmd>lua vim.diagnostic.open_float()<cr>')

    -- Move to the previous diagnostic
    bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')

    -- Move to the next diagnostic
    bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
  end
})

-- formatter setup
require("conform").setup({
  formatters_by_ft = {
    python = { "isort", "black" },
    javascript = { "prettierd" },
    typescript = { "prettierd" },
    javascriptreact = { "prettierd" },
    typescriptreact = { "prettierd" },
    css = { "prettierd" },
    json = { "prettierd" },
    markdown = { "prettierd" },
  },
})

-- format on file save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})

-- nvim-cmp (autocompletion)
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
local cmp = require('cmp')

local luasnip = require('luasnip')
require('luasnip.loaders.from_vscode').lazy_load()

require("copilot").setup({
  suggestion = { enabled = false },
  panel = { enabled = false },
})
require("copilot_cmp").setup()
cmp.event:on("menu_opened", function()
  vim.b.copilot_suggestion_hidden = true
end)

cmp.event:on("menu_closed", function()
  vim.b.copilot_suggestion_hidden = false
end)

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  sources = {
    { name = 'copilot',  keyword_length = 0 },
    { name = 'nvim_lsp', keyword_length = 1 },
    { name = 'luasnip',  keyword_length = 1 },
    { name = 'buffer',   keyword_length = 2 },
    { name = 'path', keyword_length = 3},
  },
  window = {
    documentation = cmp.config.window.bordered()
  },
  formatting = {
    fields = { 'menu', 'abbr', 'kind' },
    format = function(entry, item)
      local menu_icon = {
        copilot = 'GPT',
        nvim_lsp = 'LSP',
        luasnip = 'SNIP',
        buffer = 'BUF',
        path = 'PATH',
      }
      item.menu = menu_icon[entry.source.name]
      return item
    end,
  },
  mapping = {
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-y>'] = cmp.config.diable,
    ['<CR>'] = cmp.mapping.confirm({ select = false }),

    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
}})

-- `/` cmdline setup.
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- `:` cmdline setup.
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    {
      name = 'cmdline',
      option = {
        ignore_cmds = { 'Man', '!' }
      }
    }
  })
})

-- custom python provider
local function isempty(s)
		return s == nil or s == ""
	end
local function use_if_defined(val, fallback)
  return val ~= nil and val or fallback
end
local conda_prefix = os.getenv("CONDA_PREFIX")
if not isempty(conda_prefix) then
  vim.g.python_host_prog = use_if_defined(vim.g.python_host_prog, conda_prefix .. "/bin/python")
  vim.g.python3_host_prog = use_if_defined(vim.g.python3_host_prog, conda_prefix .. "/bin/python")
else
  vim.g.python_host_prog = use_if_defined(vim.g.python_host_prog, "python")
  vim.g.python3_host_prog = use_if_defined(vim.g.python3_host_prog, "python3")
end
