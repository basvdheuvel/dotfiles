-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.o.number = true -- line numbers
vim.o.relativenumber = false
vim.o.tabstop = 2 -- number of spaces in a tab
vim.o.shiftwidth = 2 -- number of spaces in indentation
vim.o.expandtab = true -- convert tabs to spaces
vim.o.smartindent = true -- automatically indent new lines
vim.o.wrap = true
vim.o.cursorline = true
vim.o.termguicolors = true -- 24-bit RGB
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.breakindent = true
vim.o.scrolloff = 5

vim.cmd('syntax enable')
vim.cmd('filetype plugin indent on')

vim.keymap.set('n', ';', ':')
vim.keymap.set('n', ':', ';')

vim.keymap.set('n', '<leader>nh', '<cmd>vnew<cr>')
vim.keymap.set('n', '<leader>nv', '<cmd>new<cr>')

vim.keymap.set('n', '<leader>h', '<C-w>h')
vim.keymap.set('n', '<leader>j', '<C-w>j')
vim.keymap.set('n', '<leader>k', '<C-w>k')
vim.keymap.set('n', '<leader>l', '<C-w>l')

vim.keymap.set('n', '<leader>H', '5<C-w><')
vim.keymap.set('n', '<leader>J', '5<C-w>+')
vim.keymap.set('n', '<leader>K', '5<C-w>-')
vim.keymap.set('n', '<leader>L', '5<C-w>>')

vim.keymap.set('n', '<leader><Tab>', '<cmd>tabnew<cr>')
vim.keymap.set('n', '<Tab>', '<cmd>tabnext<cr>')
vim.keymap.set('n', '<S-Tab>', '<cmd>tabprevious<cr>')

vim.keymap.set('n', '<leader>t', '<cmd>terminal<cr>A')
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

vim.keymap.set({'n','v'}, '<leader>p', 'p`[v`]')
vim.keymap.set({'n','v'}, '<leader>P', 'P`[v`]')
vim.keymap.set('v', '<leader>y', '"+y')

vim.keymap.set('i', '<C-h>', '<Left>')
vim.keymap.set('i', '<C-j>', '<Down>')
vim.keymap.set('i', '<C-k>', '<Up>')
vim.keymap.set('i', '<C-l>', '<Right>')

vim.keymap.set('i', '<C-o>', '<Esc>O')
vim.keymap.set('n', '<C-o>', 'O')

vim.keymap.set('n', '<C-t>', 'i<C-t><Esc>l')
vim.keymap.set('n', '<C-d>', 'i<C-d><Esc>l')
vim.keymap.set('v', '>', '>gv')
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '<C-t>', '>gv')
vim.keymap.set('v', '<C-d>', '<gv')

vim.api.nvim_create_autocmd('BufRead', {
  callback = function(opts)
    vim.api.nvim_create_autocmd('BufWinEnter', {
      once = true,
      buffer = opts.buf,
      callback = function()
        local ft = vim.bo[opts.buf].filetype
        local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
        if
          not (ft:match('commit') and ft:match('rebase'))
          and last_known_line > 1
          and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
        then
          vim.api.nvim_feedkeys([[g`"]], 'nx', false)
        end
      end,
    })
  end,
})

-- Setup lazy.nvim
require("lazy").setup({

  spec = {

    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      config = function()
        vim.o.background = "dark"
        vim.cmd.colorscheme "tokyonight-night"
      end
    },

    {
      "mikesmithgh/borderline.nvim",
      enabled = true,
      lazy = true,
      event = "VeryLazy",
      priority = 999,
      config = function()
        require('borderline').setup({
        })
      end
    },

    {
      "nvim-telescope/telescope.nvim",
      branch = "0.1.x",
      dependencies = {"nvim-lua/plenary.nvim"},
      config = function()
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
        vim.keymap.set('n', '<leader>fh', function()
          builtin.find_files({ hidden = true })
        end, { desc = 'Telescope find files (hidden included' })
        vim.keymap.set('n', '<leader>f/', builtin.current_buffer_fuzzy_find, { desc = 'Telescope fuzzy search current buffer' })
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
        vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
      end
    },

    {
      "numToStr/Comment.nvim",
      config = function()
        require('Comment').setup()
        vim.keymap.set('n', '<leader>/', 'gcc' , { remap = true })
        vim.keymap.set('n', '<leader>*', 'gbc' , { remap = true })
        vim.keymap.set('v', '<leader>/', 'gc' , { remap = true })
        vim.keymap.set('v', '<leader>*', 'gb' , { remap = true })
      end
    },

    {
      "nvim-treesitter/nvim-treesitter",
      branch = "master",
      lazy = false,
      build = ":TSUpdate"
    },

    {
      "mason-org/mason.nvim",
      opts = {}
    },

    {
      "neovim/nvim-lspconfig",
      config = function()

        vim.lsp.enable('solargraph')
        vim.lsp.enable('rubocop')
        vim.lsp.enable('marksman')

        vim.keymap.set('n', 'K', function()
          vim.lsp.buf.hover { border = 'single' }
        end)

        vim.api.nvim_set_keymap('n', '<leader>dd', '<cmd>Telescope diagnostics<CR>', { noremap = true, silent = true })
      end
    },

    {
      "hrsh7th/nvim-cmp",
      dependencies = {"hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "hrsh7th/cmp-cmdline"},
      config = function()
        local cmp = require'cmp'

        cmp.setup({
          window = {
            -- completion = cmp.config.window.bordered(),
            -- documentation = cmp.config.window.bordered(),
          },
          preselect = cmp.PreselectMode.Item,
          mapping = cmp.mapping.preset.insert({
            ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
            ["<C-b>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
            ['<C-Space>'] = cmp.mapping.confirm({ select = true }),
            ['<C-e>'] = cmp.mapping.abort(),
          }),
          experimental = { ghost_text = true },
          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
          }, {
            { name = 'buffer' },
          })
        })

        -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline({ '/', '?' }, {
          mapping = cmp.mapping.preset.cmdline(),
          sources = {
            { name = 'buffer' }
          }
        })

        -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline(':', {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
            { name = 'path' }
          }, {
            { name = 'cmdline' }
          }),
          matching = { disallow_symbol_nonprefix_matching = false }
        })

        -- Set up lspconfig.
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
        vim.lsp.config('solargraph', { capabilities = capabilities })
        vim.lsp.config('rubocop', { capabilities = capabilities })
      end
    },

    {
      "andrewferrier/wrapping.nvim",
      config = function()
        require("wrapping").setup()
      end,
    },

    {
      'dgagn/diagflow.nvim',
      event = 'LspAttach',
      opts = {
        show_borders = true,
        scope = 'line',
      }
    },

    {
      'Aasim-A/scrollEOF.nvim',
      event = { 'CursorMoved', 'WinScrolled' },
      opts = {},
    },

  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
