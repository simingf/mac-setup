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

-- ========================================================================== --
-- ==                           KEY BINDINGS                               == --
-- ========================================================================== --

-- set the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- copy
vim.keymap.set({'n', 'x'}, '<leader>y', '"+y')
-- paste
vim.keymap.set({'n', 'x'}, '<leader>p', '"+p')
-- prevent x or X from modifying the internal register
vim.keymap.set({'n', 'x'}, 'x', '"_x')
vim.keymap.set({'n', 'x'}, 'X', '"_d')
-- select all text in current buffer
vim.keymap.set('n', '<leader>a', ':keepjumps normal! ggVG<cr>')

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
  {"lukas-reineke/indent-blankline.nvim"},
  -- editor utilities
  {'nvim-treesitter/nvim-treesitter'},
  {'nvim-treesitter/nvim-treesitter-textobjects'},
  {'numToStr/Comment.nvim'},
  {'tpope/vim-surround'},
  {'tpope/vim-repeat'},
  -- file system
  {'kyazdani42/nvim-tree.lua'},
  {'nvim-telescope/telescope.nvim'},
  {'moll/vim-bbye'},
  -- git
  {'tpope/vim-fugitive'},
  {'lewis6991/gitsigns.nvim'},
  -- lsp & cmp
  {'williamboman/mason.nvim'},
  {'williamboman/mason-lspconfig.nvim'},
  {'neovim/nvim-lspconfig'},
  {'hrsh7th/nvim-cmp'},
  {'hrsh7th/cmp-buffer'},
  {'hrsh7th/cmp-path'},
  {'saadparwaiz1/cmp_luasnip'},
  {'hrsh7th/cmp-nvim-lsp'},
  {'L3MON4D3/LuaSnip'},
  {'rafamadriz/friendly-snippets'},
})

-- ========================================================================== --
-- ==                         PLUGIN CONFIGURATION                         == --
-- ========================================================================== --

-- gruvbox (theme)
vim.cmd.colorscheme('gruvbox')

-- lualine (better status line at the bottom)
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

-- treesitter (creates syntax tree for various languages)
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
    'python', 'csv', 'java', 'c', 'cpp', 'javascript', 'typescript', 'html', 'css', 'json', 'bash', 'lua', 'latex'
  },
})

-- comment using 'gc'
require('Comment').setup({})

-- nvim-tree (file explorer)
require('nvim-tree').setup({
  hijack_cursor = false,
  on_attach = function(bufnr)
    local bufmap = function(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, {buffer = bufnr, desc = desc})
    end

    -- See :help nvim-tree.api
    local api = require('nvim-tree.api')
   
    bufmap('J', api.node.open.edit, 'Expand folder or go to file')
    bufmap('K', api.node.navigate.parent_close, 'Close parent folder')
    bufmap('gh', api.tree.toggle_hidden_filter, 'Toggle hidden files')
  end
})

vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<cr>')

-- telescope (search / filter files)
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

-- vim-bbye (close buffer without closing window)
vim.keymap.set('n', '<leader>cb', '<cmd>Bdelete<CR>')

-- gitsigns
require('gitsigns').setup({
  signs = {
    add = {text = '▎'},
    change = {text = '▎'},
    delete = {text = '➤'},
    topdelete = {text = '➤'},
    changedelete = {text = '▎'},
  }
})

-- lsp
require('mason').setup()
require('mason-lspconfig').setup()

local lspconfig = require('lspconfig')
lspconfig.lua_ls.setup({})
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
lspconfig.lua_ls.setup({
  capabilities = lsp_capabilities,
})

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function()
    local bufmap = function(mode, lhs, rhs)
      local opts = {buffer = true}
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- Displays hover information about the symbol under the cursor
    bufmap('n', '<leader>K', '<cmd>lua vim.lsp.buf.hover()<cr>')

    -- Jump to the definition
    bufmap('n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<cr>')

    -- Jump to declaration
    bufmap('n', '<leader>gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')

    -- Lists all the implementations for the symbol under the cursor
    bufmap('n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')

    -- Jumps to the definition of the type symbol
    bufmap('n', '<leader>go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')

    -- Lists all the references 
    bufmap('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<cr>')

    -- Displays a function's signature information
    bufmap('n', '<leader>gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>')

    -- Renames all references to the symbol under the cursor
    bufmap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>')

    -- Selects a code action available at the current cursor position
    bufmap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>')

    -- Show diagnostics in a floating window
    bufmap('n', '<leader>gl', '<cmd>lua vim.diagnostic.open_float()<cr>')

    -- Move to the previous diagnostic
    bufmap('n', '<leader>[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')

    -- Move to the next diagnostic
    bufmap('n', '<leader>]d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
  end
})

-- snippets
require('luasnip.loaders.from_vscode').lazy_load()

-- nvim-cmp (autocompletion)
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
require('luasnip.loaders.from_vscode').lazy_load()
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
    -- file paths
    {name = 'path'},
    -- lsp responses
    {name = 'nvim_lsp', keyword_length = 1},
    -- available snippets
    {name = 'luasnip', keyword_length = 2},
    -- words found in current buffer
    {name = 'buffer', keyword_length = 3},
  },
  window = {
    documentation = cmp.config.window.bordered()
  },
  formatting = {
    fields = {'menu', 'abbr', 'kind'},
    format = function(entry, item)
      local menu_icon = {
        -- symbols for where the completion suggestion came from
        nvim_lsp = 'λ',
        luasnip = '⋗',
        buffer = 'Ω',
        path = '🖫',
      }
      item.menu = menu_icon[entry.source.name]
      return item
    end,
  },
  mapping = {
    ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
    ['<Down>'] = cmp.mapping.select_next_item(select_opts),
    -- scroll up
    ['<C-p>'] = cmp.mapping.scroll_docs(-4),
    -- scroll down
    ['<C-n>'] = cmp.mapping.scroll_docs(4),
    -- cancel completion
    ['<C-e>'] = cmp.mapping.abort(),
    -- confirm selection
    ['<C-y>'] = cmp.mapping.confirm({select = true}),
    ['<CR>'] = cmp.mapping.confirm({select = false}),
    -- jump to the next placeholder in the snippet
    ['<C-f>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end, {'i', 's'}),
    -- jump to the previous placeholder in the snippet
    ['<C-b>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {'i', 's'}),
    -- if empty line, insert tab. else open completion menu. if already open, move to next item.
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
    -- if completion menu visible, move to prev item
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item(select_opts)
      else
        fallback()
      end
    end, {'i', 's'}),
  },
})

-- diagnostic config
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

-- rounded borders for floating windows
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover,
  {border = 'rounded'}
)
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  {border = 'rounded'}
)