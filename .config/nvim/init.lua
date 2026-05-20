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

-- To prevent 4-space indentation
vim.g.markdown_recommended_style = 0

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
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions" -- recommended for AutoSession
vim.o.foldenable = false

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

vim.keymap.set({'n','v'}, 'j', 'gj')
vim.keymap.set({'n','v'}, 'k', 'gk')

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


vim.keymap.set('n', '<leader>/', 'gcc', { remap = true })
vim.keymap.set('v', '<leader>/', 'gc', { remap = true })
vim.keymap.set('n', '<leader>*', 'gbc', { remap = true })
vim.keymap.set('v', '<leader>*', 'gb', { remap = true })
vim.api.nvim_create_autocmd({"FileType"}, {
  pattern = {"gitcommit", "gitrebase", "gitconfig", "gitsendmail"},
  command = "set bufhidden=delete"
})

vim.api.nvim_create_autocmd({"FileType"}, {
  pattern = {"qf"},
  callback = function()
    vim.keymap.set('n', '<leader>h', '<C-w><Enter><C-w>L', {buffer = true})
    vim.keymap.set('n', '<leader>v', '<C-w><Enter>', {buffer = true})
  end
})

vim.api.nvim_create_autocmd({"FileType"}, {
  pattern = {"ruby", "python"},
  callback = function()
    vim.opt_local.textwidth = 100
    vim.o.tabstop = 2 -- number of spaces in a tab
    vim.o.shiftwidth = 2 -- number of spaces in indentation
    vim.o.expandtab = true -- convert tabs to spaces
  end
})

vim.api.nvim_create_autocmd({"BufWritePre"}, {
  pattern = {"*"},
  command = [[%s/\s\+$//e]],
})

if vim.fn.has("nvim") then
  vim.env.GIT_EDITOR = "nvr -cc split --remote-wait"
end

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
      "xiyaowong/transparent.nvim",
      lazy = false,
      priority = 1001,
      config = function()
        local transparent = require("transparent")
        transparent.setup({
          exclude_groups = { "Todo" },  -- Don't make Todo transparent
        })
        transparent.toggle(true)
      end
    },

    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      config = function()
        require("tokyonight").setup{ transparent = vim.g.transparent_enabled }
        vim.o.background = "dark"
        vim.cmd.colorscheme "tokyonight-night"

        -- Custom highlight for TODO with background to make it stand out
        vim.api.nvim_set_hl(0, "Todo", {
          fg = "#1a1b26",  -- Dark foreground (tokyonight background color)
          bg = "#7aa2f7",  -- Bright blue background (tokyonight blue)
          bold = true,
        })
      end
    },

    {
      "mikesmithgh/borderline.nvim",
      enabled = true,
      lazy = true,
      event = "VeryLazy",
      priority = 999,
      dependencies = {
        "ibhagwan/fzf-lua",
      },
      config = function()
        require('borderline').setup({
        })
      end
    },

    {
      "ibhagwan/fzf-lua",
      dependencies = {
        { "nvim-tree/nvim-web-devicons", opts = {} }
      },
      config = function()
        require("fzf-lua").setup({
          actions = {
            files = {
              ["default"] = require("fzf-lua.actions").file_edit_or_qf,
              ["ctrl-h"]  = require("fzf-lua.actions").file_vsplit,
              ["ctrl-v"]  = require("fzf-lua.actions").file_split,
              ["ctrl-t"]  = require("fzf-lua.actions").file_tabedit,
              ["alt-q"]   = require("fzf-lua.actions").file_sel_to_qf,
            }
          }
        })
        vim.keymap.set('n', '<leader>ff', "<cmd>FzfLua files<cr>", { desc = 'FzfLua find files' })
        vim.keymap.set('n', '<leader>fh', "<cmd>FzfLua files hidden=true<cr>", { desc = 'FzfLua find files (hidden included)' })
        vim.keymap.set('n', '<leader>f/', "<cmd>FzfLua blines<cr>", { desc = 'FzfLua fuzzy search current buffer lines' })
        vim.keymap.set('n', '<leader>fg', "<cmd>FzfLua live_grep<cr>", { desc = 'FzfLua live grep' })
        vim.keymap.set('n', '<leader>fb', "<cmd>FzfLua buffers<cr>", { desc = 'FzfLua buffers' })
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
        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        vim.lsp.config('solargraph', {
          cmd = { "solargraph", "stdio" },
          init_options = { formatting = true, diagnostics = true },
          capabilities = capabilities,
        })

        vim.lsp.config('rubocop', {
          cmd = { "bundle", "exec", "rubocop", "--lsp" },
          capabilities = capabilities,
        })

        vim.lsp.config('cssls', {
          capabilities = capabilities,
        })

        vim.lsp.config('marksman', {
          capabilities = capabilities,
        })

        vim.lsp.config('pylsp', {
          capabilities = capabilities,
        })

        vim.lsp.enable('solargraph')
        vim.lsp.enable('rubocop')
        -- vim.lsp.enable('marksman')
        vim.lsp.enable('cssls')
        vim.lsp.enable('pylsp')

        vim.keymap.set('n', 'K', function()
          vim.lsp.buf.hover { border = 'single' }
        end)

        vim.api.nvim_set_keymap('n', '<leader>dd', '<cmd>FzfLua diagnostics_document<CR>', { noremap = true, silent = true })
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
            ['<C-e'] = cmp.mapping.confirm({ select = true }),
            ['<C-q>'] = cmp.mapping.abort(),
          }),
          experimental = { ghost_text = true },
          sources = cmp.config.sources(
            {
              { name = 'nvim_lsp' },
            }, {
              { name = 'buffer' },
            }
          )
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
      end
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

    {
      'lewis6991/gitsigns.nvim',
      tag = 'release',
      config = function()
        require('gitsigns').setup{
          on_attach = function(bufnr)
            local gitsigns = require('gitsigns')

            local function map(mode, l, r, opts)
              opts = opts or {}
              opts.buffer = bufnr
              vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map('n', ']c', function()
              if vim.wo.diff then
                vim.cmd.normal({']c', bang = true})
              else
                gitsigns.nav_hunk('next')
              end
            end)

            map('n', '[c', function()
              if vim.wo.diff then
                vim.cmd.normal({'[c', bang = true})
              else
                gitsigns.nav_hunk('prev')
              end
            end)

            -- Actions
            map('n', '<leader>ss', gitsigns.stage_hunk)
            map('n', '<leader>sS', gitsigns.stage_buffer)
            map('v', '<leader>ss', function()
              gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
            end)

            map('n', '<leader>sr', gitsigns.reset_hunk)
            map('n', '<leader>sR', gitsigns.reset_buffer)
            map('v', '<leader>sr', function()
              gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
            end)

            map('n', '<leader>sp', gitsigns.preview_hunk)
            map('n', '<leader>si', gitsigns.preview_hunk_inline)

            map('n', '<leader>sb', function()
              gitsigns.blame_line({ full = true })
            end)

            map('n', '<leader>sd', gitsigns.diffthis)
            map('n', '<leader>sD', function()
              gitsigns.diffthis('~')
            end)

            map('n', '<leader>sQ', function() gitsigns.setqflist('all') end)
            map('n', '<leader>sq', gitsigns.setqflist)

            -- Toggles
            map('n', '<leader>stb', gitsigns.toggle_current_line_blame)
            map('n', '<leader>std', gitsigns.toggle_deleted)
            map('n', '<leader>stw', gitsigns.toggle_word_diff)

            -- Text object
            map({'o', 'x'}, 'sih', gitsigns.select_hunk)
          end
        }
      end
    },

    {
      'rmagatti/auto-session',
      lazy = false,
      ---@module 'auto-session'
      ---@type AutoSession.Config
      opts = {
        suppressed_dirs = {},
      },
    },

  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
