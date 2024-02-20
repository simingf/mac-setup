-- ========================================================================== --
-- ==                           EDITOR SETTINGS                            == --
-- ========================================================================== --

-- enable line numbers
vim.opt.number = true
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
vim.keymap.set({'n', 'x'}, 'gy', '"+y')
-- paste
vim.keymap.set({'n', 'x'}, 'gp', '"+p')
-- prevent x or X from modifying the internal register
vim.keymap.set({'n', 'x'}, 'x', '"_x')
vim.keymap.set({'n', 'x'}, 'X', '"_d')
-- select all text in current buffer
vim.keymap.set('n', '<leader>a', ':keepjumps normal! ggVG<cr>')
-- swap windows
vim.api.nvim_set_keymap('n', '<Leader>w', '<C-w>', {noremap = true, silent = true})

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

sign({name = 'DiagnosticSignError', text = '✘'})
sign({name = 'DiagnosticSignWarn', text = '▲'})
sign({name = 'DiagnosticSignHint', text = '⚑'})
sign({name = 'DiagnosticSignInfo', text = '»'})

-- configure diagnostic options
vim.diagnostic.config({
  -- Show diagnostic message using virtual text.
  virtual_text = true,
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
        {"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", -- latest stable release
         lazypath})
end
vim.opt.rtp:prepend(lazypath)
-- setup code from documentation --

require("lazy").setup({
  -- dependencies
  {'nvim-lua/plenary.nvim'},
  {'kyazdani42/nvim-web-devicons'},
  -- theme
  {"ellisonleao/gruvbox.nvim"},
  -- editor ui
  {'nvim-lualine/lualine.nvim'},
  {'akinsho/bufferline.nvim'},
  {'echasnovski/mini.bufremove'},
  {"lukas-reineke/indent-blankline.nvim"},
  {'echasnovski/mini.cursorword'},
  -- editor utilities
  {'nvim-treesitter/nvim-treesitter'},
  {'nvim-treesitter/nvim-treesitter-textobjects'},
  {'echasnovski/mini.comment'},
  {'tpope/vim-surround'},
  -- file system
  {'kyazdani42/nvim-tree.lua'},
  {'nvim-telescope/telescope.nvim'},
  {'nvim-telescope/telescope-fzf-native.nvim', build = 'make'},
  -- lsp & cmp
  {'williamboman/mason.nvim'},
  {'williamboman/mason-lspconfig.nvim'},
  {'neovim/nvim-lspconfig'},
  {'hrsh7th/nvim-cmp'},
  {'hrsh7th/cmp-buffer'},
  {'hrsh7th/cmp-path'},
  {'hrsh7th/cmp-nvim-lsp'},
  -- snippet
  {'saadparwaiz1/cmp_luasnip'},
  {'L3MON4D3/LuaSnip'},
  {'rafamadriz/friendly-snippets'},
})

-- ========================================================================== --
-- ==                         CONFIGURATION                                == --
-- ========================================================================== --

-- gruvbox (theme)
vim.cmd.colorscheme('gruvbox')

-- lualine (better status line at the bottom)
-- See :help lualine.txt
require('lualine').setup({
    options = {
        theme = 'gruvbox',
        icons_enabled = true,
        section_separators = '',
        component_separators = '|'
    }
})

-- bufferline (shows open files as tabs at top)
require('bufferline').setup({
  options = {
    -- one tab per file
    mode = 'buffers',
    offsets = {
      {filetype = 'NvimTree'}
    },
  },
  highlights = {
    buffer_selected = {
      italic = false
    },
    indicator_selected = {
      fg = {attribute = 'fg', highlight = 'Function'},
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
    'vim', 'vimdoc', 'lua', 'python', 'java', 'c', 'cpp', 'javascript', 'typescript', 'json', 'bash', 'latex'
  },
})

-- use gcc to comment a line
require('mini.comment').setup({})

-- nvim-tree (file explorer)
require('nvim-tree').setup({
  view = {
    width = 30,
  },
  hijack_cursor = false,
  on_attach = function(bufnr)
    local bufmap = function(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, {buffer = bufnr, desc = desc})
    end

    -- See :help nvim-tree.api
    local api = require('nvim-tree.api')
    bufmap('<cr>', api.node.open.edit, 'Expand folder or go to file')
    bufmap('cd', api.tree.change_root_to_node, 'Set current directory as root')
    bufmap('..', api.node.navigate.parent, 'Move to parent directory')
    bufmap('gh', api.tree.toggle_hidden_filter, 'Toggle hidden files')
  end
})

vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<cr>')

-- telescope (search / filter files)
-- See :help telescope.builtin
-- search open files
vim.keymap.set('n', '<leader><space>', '<cmd>Telescope buffers<cr>')
-- search recently opened files
vim.keymap.set('n', '<leader>?', '<cmd>Telescope oldfiles<cr>')
-- search files in current directory
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
-- grep for a pattern in current directory
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>')
-- search diagnostic messages
vim.keymap.set('n', '<leader>fd', '<cmd>Telescope diagnostics<cr>')
-- fzf for a pattern in the current file
vim.keymap.set('n', '<leader>fs', '<cmd>Telescope current_buffer_fuzzy_find<cr>')

-- lsp (language server)
require('mason').setup()
require('mason-lspconfig').setup()

local lspconfig = require('lspconfig')
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.lua_ls.setup({
  capabilities = lsp_capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = {'vim'}
      }
    }
  }
})

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function()
    local bufmap = function(mode, lhs, rhs)
      local opts = {buffer = true}
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- Displays hover information about the symbol under the cursor
    bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')

    -- Jump to the definition
    bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')

    -- Jump to declaration
    bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')

    -- Lists all the implementations for the symbol under the cursor
    bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')

    -- Jumps to the definition of the type symbol
    bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')

    -- Lists all the references 
    bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')

    -- Displays a function's signature information
    bufmap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>')

    -- Renames all references to the symbol under the cursor
    bufmap('n', 'gR', '<cmd>lua vim.lsp.buf.rename()<cr>')

    -- Selects a code action available at the current cursor position
    bufmap('n', 'gc', '<cmd>lua vim.lsp.buf.code_action()<cr>')

    -- Show diagnostics in a floating window
    bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')

    -- Move to the previous diagnostic
    bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')

    -- Move to the next diagnostic
    bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
  end
})

-- load installed snippets
require('luasnip.loaders.from_vscode').lazy_load()

-- nvim-cmp (autocompletion)
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
local cmp = require('cmp')
local luasnip = require('luasnip')
local select_opts = {behavior = cmp.SelectBehavior.Select}

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  sources = {
    {name = 'nvim_lsp', keyword_length = 1},
    {name = 'luasnip', keyword_length = 2},
    {name = 'buffer', keyword_length = 3},
    {name = 'path'},
  },
  window = {
    documentation = cmp.config.window.bordered()
  },
  formatting = {
    fields = {'menu', 'abbr', 'kind'},
    format = function(entry, item)
      local menu_icon = {
        nvim_lsp = 'L',
        luasnip = 'S',
        buffer = 'B',
        path = 'P',
      }
      item.menu = menu_icon[entry.source.name]
      return item
    end,
  },
  mapping = {
    ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
    ['<Down>'] = cmp.mapping.select_next_item(select_opts),

    ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
    ['<C-n>'] = cmp.mapping.select_next_item(select_opts),

    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),

    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-y>'] = cmp.mapping.confirm({select = true}),
    ['<CR>'] = cmp.mapping.confirm({select = false}),

    ['<Tab>'] = cmp.mapping(function(fallback)
      local col = vim.fn.col('.') - 1

      if cmp.visible() then
        cmp.select_next_item(select_opts)
      elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        fallback()
      else
        cmp.complete()
      end
    end, {'i', 's'}),

    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item(select_opts)
      else
        fallback()
      end
    end, {'i', 's'}),
  },
})

