-- ---------------------------
--[[ 写在开头，常用的使用命令

# SPELLING
]s                  next misspelled word
[s                  previous misspelled word
zg                  add word to wordlist
zug                 undo last add word
z=                  suggest word


:%s/old/new/g       replace all old with new throughout file
:%s/old/new/gc      replace all old with new throughout file with confirmation

:bn                 go to next buffer
:bp                 go to previous buffer
:bd                 delete a buffer (close a file)

zz                  Centers the window to the current line


~                 switch case
gU                make current word uppercase
gu                make current word lowercase


## folder
zM 	Close all
zR 	Open all

zm 	Fold more (foldlevel += 1)
zr 	Fold less (foldlevel -= 1)

za Toggle

--]]

-- ---------------------------
-- 基础配置
-- ---------------------------
vim.o.tabstop = 4            -- tab键是空格还是tab
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.termguicolors = true   -- 设置颜色
vim.o.cursorline = true      -- 当前光标所在的行高亮
vim.o.number = true          -- 显示行号
vim.o.relativenumber = true  -- 使用相对行号
vim.o.mouse = "a"            -- 鼠标支持
vim.o.clipboard = "unnamedplus"
vim.o.signcolumn = "yes"     -- 显示左侧图标指示列
vim.o.colorcolumn = "120"    -- 右侧参考线，超过表示代码太长了，考虑换行
vim.o.ignorecase = true      -- 是否在搜索时忽略大小写
-- 是否开启在搜索时如果有大写字母，则关闭忽略大小写的选项
vim.o.smartcase = true
-- 搜索不要高亮
vim.o.hlsearch = true
-- 边输入边搜索
vim.o.incsearch = true
-- 使用增强状态栏后不再需要 vim 的模式提示
vim.o.showmode = false
-- 不可见字符显示
vim.o.listchars = "space:·"
vim.o.wildmenu = true -- 补全增强
vim.o.showtabline = 2  -- always show tabline
vim.o.cmdheight = 1  -- 命令行高
vim.o.spell = false
-- 设定单词拼写检查的语言
vim.o.spelllang = "en,cjk"
vim.g.mapleader = " " -- 设置leader键
vim.g.completeopt = "menu,menuone,noselect,noinsert"
-- 折叠设置
vim.wo.foldmethod = 'indent'
-- 打开一个文件的时候，默认不折叠
vim.wo.foldlevel = 99
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'

-- 配置主题
vim.o.background = 'dark'  -- 背景为dark

------------------------------
--[[
  从这里开始配置插件
--]]
------------------------------
-- 使用packer管理要安装的插件
require('packer').startup(function()
    -- packer插件, 用来进行插件管理的插件
    use 'wbthomason/packer.nvim'
    -- vscode 主题插件
    use 'Mofiqul/vscode.nvim'
    -- lsp插件
    use { 'neovim/nvim-lspconfig','williamboman/mason.nvim' }
    -- explore 插件
    use 'nvim-tree/nvim-tree.lua'
    -- structure 插件
    -- 查找文件,字符串插件
    use {'nvim-telescope/telescope.nvim', tag = '0.1.1', requires = {{'nvim-lua/plenary.nvim'}}}
    -- git
    use {'kdheepak/lazygit.nvim'}
    -- 格式化formater
    use 'sbdchd/neoformat'
    -- 浮动终端
    use "numToStr/FTerm.nvim";
    -- buffer 管理
    use {'akinsho/bufferline.nvim', requires = 'kyazdani42/nvim-web-devicons'}
    -- 项目管理
    use 'ahmedkhalf/project.nvim'
    -- 代码注释
    use 'numToStr/Comment.nvim'
    -- 底部line配置
    use {'nvim-lualine/lualine.nvim'}
    -- 配置gr引用不再quickfix中显示
    use {'ojroques/nvim-lspfuzzy', requires = {{'junegunn/fzf'},{'junegunn/fzf.vim'}}}
    -- 配置outline
    use 'simrat39/symbols-outline.nvim'
    -- 基于lsp的代码补全插件
    use 'hrsh7th/nvim-cmp'  -- 补全的插件
    use 'hrsh7th/cmp-nvim-lsp'  -- 使用lsp作为补全的来源
    use 'hrsh7th/cmp-vsnip'
    -- 瞬间移动
    use {'ggandor/leap.nvim'}
    -- treesitter进行语法树解析
    use 'nvim-treesitter/nvim-treesitter'
    -- 测试用的插件
    use 'klen/nvim-test'
    -- 自动配对插件
    use "windwp/nvim-autopairs"
    -- git改动的地方高亮显示
    use 'lewis6991/gitsigns.nvim'
    -- todo
    use { 'ackeraa/todo.nvim' }
    -- markdown previw
    use{"iamcco/markdown-preview.nvim", run = function() vim.fn["mkdp#util#install"]() end }
end)

------------------------------
--[[
 具体插件的配置
--]]
-- ---------------------------
-- 配置快捷键
local options = { noremap = true , silent = true}
local map = vim.api.nvim_set_keymap

map('n', '<c-h>', '<c-w><c-h>', options)
map('n', '<c-j>', '<c-w><c-j>', options)
map('n', '<c-k>', '<c-w><c-k>', options)
map('n', '<c-l>', '<c-w><c-l>', options)
map('n', '<leader>qa', ':qa<CR>', options)

-- vscode主题配置
local c = require('vscode.colors').get_colors()
require('vscode').setup({
    transparent = true,
    italic_comments = true,
    disable_nvimtree_bg = true,
    color_overrides = {
        vscLineNumber = '#FFFFFF',
    },
    group_overrides = {
        Cursor = { fg=c.vscDarkBlue, bg=c.vscLightGreen, bold=true },
    }
})
vim.cmd("colorscheme vscode")

-- lspconfig 插件配置
local nvimlsp = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>d', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
end

local servers = { 'pyright', 'rust_analyzer', 'tsserver', 'gopls', 'clangd', 'lua_ls', 'jdtls'}
for _, lsp in ipairs(servers) do
  nvimlsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    settings = {
        Lua = {
          diagnostics = {
            globals = {'vim', 'use'},
          },
        },
    },
  }
end

-- lsp,dap等工具的管理插件
require("mason").setup()

-- nvim-tree 配置
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require("nvim-tree").setup()
map("n", "<leader>e", ":NvimTreeToggle<CR>", options)
-- 配置自动关闭
vim.api.nvim_create_autocmd("BufEnter", {
  nested = true,
  callback = function()
    if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
      vim.cmd "quit"
    end
  end
})

-- telescope 配置
require('telescope').setup()
map('n', '<leader>ff', ':Telescope find_files<cr>', options)
map('n', '<leader>fl', ':Telescope live_grep<cr>', options)
map('n', '<leader>fb', ':Telescope buffers<cr>', options)
map('n', '<leader>fp', ':Telescope projects<cr>', options)
map('n', '<leader>fh', ':Telescope help_tags<cr>', options)

-- lazygit配置
map('n', '<leader>gg',':LazyGit<CR>', options)

-- 格式化formater配置
map('n', '<leader>fc', ':Neoformat<CR>', options)

-- Fterm配置
map('n', '<C-\\>', '<CMD>lua require("FTerm").open()<CR>', options)
map('t', '<C-\\>', '<CMD>lua require("FTerm").close()<CR>', options)

-- buffer 切换配置
require('bufferline').setup {}
map('n', '<leader>n',':BufferLinePick<CR>', options)

-- project 管理配置
require("project_nvim").setup()
require('telescope').load_extension('projects')

-- 注释插件配置
-- 默认的快捷键就是gc/gcc
require('Comment').setup()

-- lualine 底部栏配置
require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '|', right = '|'},
        section_separators = { left = '', right = ''},
        always_divide_middle = true,
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff'},
        lualine_c = { {'filename', file_status = true, path = 1} },
        lualine_x = {'encoding'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    }
}

-- lspfuzzy 配置
require('lspfuzzy').setup {}

-- outline配置
require("symbols-outline").setup()
map('n', '<leader>o',':SymbolsOutline<CR>', options)

-- 基于lsp的自动补全
local cmp = require'cmp'
cmp.setup {
  -- 指定 snippet 引擎
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  -- 来源
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  }),

  -- 快捷键
  mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
}

-- 瞬间移动配置, 使用s/S开启瞬间移动
require('leap').add_default_mappings()

-- treesitter 配置支持语法高亮
require'nvim-treesitter.configs'.setup {
  -- 支持高亮
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  -- 支持缩进
  indent = {
    enable = true
  },
}

-- test插件配置
require('nvim-test').setup({
  termOpts = {
    direction = "float",   -- terminal's direction ("horizontal"|"vertical"|"float")
  },
})
map('n', '<leader>tt',':TestNearest<CR>', options)

-- autopari插件配置
require("nvim-autopairs").setup()

-- gitsign配置
require('gitsigns').setup({
  current_line_blame = true,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'right_align',
    delay = 100,
    ignore_whitespace = true,
  },
})
map('n', '<leader>pc', ':Gitsigns prev_hunk<cr>', options)

-- todo配置
require("todo").setup {
    opts = {
        file_path = "/Users/cody/workspace/todo/todo.md"
    },
}
map('n', '<leader>to', ':Todo<cr>', options)

-- markdown preview配置
