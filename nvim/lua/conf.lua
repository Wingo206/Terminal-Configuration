-- nvim-tree
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
local function my_on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.config.mappings.default_on_attach(bufnr)

  -- your removals and mappings go here
  local function dummy()
    print("hi")
  end
  vim.keymap.set('n', '<Tab>', dummy, opts('broga'))
end

require("nvim-tree").setup({
  view = {
    float = {
      enable = false
    },
  },
  tab = {
    sync = {
      open = true,
      close = true,
      ignore = {},
    },
  },
  on_attach = my_on_attach,
})

-- Telescope setup
require('telescope').setup {
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    }
  }
}
require('telescope').load_extension('fzf')

-- Treesitter setup
require 'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  ignore_install = {},

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { "javascript", "make", "md" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    -- disable = function(lang, buf)
    --     local max_filesize = 100 * 1024 -- 100 KB
    --     local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    --     if ok and stats and stats.size > max_filesize then
    --         return true
    --     end
    -- end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },

  indent = {
    enable = false,
  }
}

-- Lualine setup

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'palenight',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
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
    }
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

-- nvim-surround setup
require( "nvim-surround" ).setup({

})

-- gesture setup
-- vim.opt.mouse = "a"
-- vim.opt.mousemoveevent = true

-- vim.keymap.set("n", "<LeftDrag>", [[<Cmd>lua require("gesture").draw()<CR>]], { silent = true })
-- vim.keymap.set("n", "<LeftRelease>", [[<Cmd>lua require("gesture").finish()<CR>]], { silent = true })

-- local gesture = require("gesture")
-- gesture.register({
--   name = "scroll to bottom",
--   inputs = { gesture.up(), gesture.down() },
--   action = "normal! G",
-- })

-- neovim session manager
local Path = require('plenary.path')
local config = require('session_manager.config')
require('session_manager').setup({
  sessions_dir = Path:new(vim.fn.stdpath('data'), 'sessions'), -- The directory where the session files will be saved.
  session_filename_to_dir = session_filename_to_dir,           -- Function that replaces symbols into separators and colons to transform filename into a session directory.
  dir_to_session_filename = dir_to_session_filename,           -- Function that replaces separators and colons into special symbols to transform session directory into a filename. Should use `vim.loop.cwd()` if the passed `dir` is `nil`.
  autoload_mode = config.AutoloadMode.CurrentDir,              -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
  autosave_last_session = true,                                -- Automatically save last session on exit and on session switch.
  autosave_ignore_not_normal = true,                           -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
  autosave_ignore_dirs = {},                                   -- A list of directories where the session will not be autosaved.
  autosave_ignore_filetypes = {                                -- All buffers of these file types will be closed before the session is saved.
    'gitcommit',
    'gitrebase',
  },
  autosave_ignore_buftypes = {},                                      -- All buffers of these bufer types will be closed before the session is saved.
  autosave_only_in_session = false,                                   -- Always autosaves session. If true, only autosaves after a session is active.
  max_path_length = 80,                                               -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
})
local config_group = vim.api.nvim_create_augroup('MyConfigGroup', {}) -- A global group for all your config autocommands

vim.api.nvim_create_autocmd({ 'User' }, {
  pattern = "SessionSavePre",
  group = config_group,
  callback = function()
    vim.api.nvim_command('Bdelete hidden')
  end,
})

-- neoscroll
-- require('neoscroll').setup()

-- mini.map
-- require('mini.map').setup()
-- vim.keymap.set('n', '<leader>mm', require('mini.map').toggle)

-- codewindow
-- local codewindow = require('codewindow')
-- codewindow.setup({
--   active_in_terminals = false, -- Should the minimap activate for terminal buffers
--   auto_enable = false, -- Automatically open the minimap when entering a (non-excluded) buffer (accepts a table of filetypes)
--   exclude_filetypes = { 'help' }, -- Choose certain filetypes to not show minimap on
--   max_minimap_height = nil, -- The maximum height the minimap can take (including borders)
--   max_lines = nil, -- If auto_enable is true, don't open the minimap for buffers which have more than this many lines.
--   minimap_width = 8, -- The width of the text part of the minimap
--   use_lsp = true, -- Use the builtin LSP to show errors and warnings
--   use_treesitter = true, -- Use nvim-treesitter to highlight the code
--   use_git = true, -- Show small dots to indicate git additions and deletions
--   width_multiplier = 4, -- How many characters one dot represents
--   z_index = 1, -- The z-index the floating window will be on
--   show_cursor = true, -- Show the cursor position in the minimap
--   screen_bounds = 'lines', -- How the visible area is displayed, "lines": lines above and below, "background": background color
--   window_border = 'single', -- The border style of the floating window (accepts all usual options)
--   relative = 'win', -- What will be the minimap be placed relative to, "win": the current window, "editor": the entire editor
--   events = { 'TextChanged', 'InsertLeave', 'DiagnosticChanged', 'FileWritePost' } -- Events that update the code window
-- })
-- codewindow.apply_default_keybinds()
-- vim.keymap.set('n', '<leader>m', codewindow.toggle_minimap)

-- nvim-scrollview
-- require('scrollview').setup({
--   excluded_filetypes = {'nerdtree'},
--   current_only = true,
--   base = 'buffer',
--   column = 800,
--   signs_on_startup = {'all'},
--   diagnostics_severities = {vim.diagnostic.severity.ERROR}
-- })
--vim.g.scrollview_signs_on_startup = {'all'}
