"####################vim配置好复杂###########################
" 但是我还是要配置
" 在编写vim配置时，可以先尝试相应的设置, 方法是使用命令模式:
" 先输入冒号，然后输入对一个的命令
", 例如：尝试配色 :colorscheme<name>
"####################常用基础配置################
"
" define leader key
let mapleader=';'

syntax on                       "支持语法高亮
filetype plugin indent on       "根据文件类型自动缩进
set autoindent                  "开始新行时处理缩进
set expandtab                   "将tab键展开为空格
set tabstop=4                   "要计算的空格数
set shiftwidth=4                "用于自动缩进的空格数
set backspace=2                 "修改正backspace的行为
set nu                          "显示行号
colorscheme  morning            "设置配色
"set foldmethod=indent          "基于缩进来折叠代码
"set foldmethod=syntax          "基于语法来折叠代码
set directory=$HOME/.vim/swap/  "将swap文件放在指定路径下
set hlsearch                    "输入字符串就显示匹配点
set incsearch                   "搜索过程中动态的显示匹配的内容
set showcmd                     "输入的命令显示出来，看的清楚些。
set laststatus=2                "设置显示状态栏
set colorcolumn=81              "设置超过81字符显示
set list lcs=tab:\|\            "设置缩进对齐线
set cursorline                  "突出显示当前行
set showmatch                   "显示括号匹配

"################常用映射配置####################

" 打开多个窗口时,绑定窗口切换的快捷键
noremap <c-h> <c-w><c-h>
noremap <c-j> <c-w><c-j>
noremap <c-k> <c-w><c-k>
noremap <c-l> <c-w><c-l>
noremap <leader>s <c-w>s
noremap <leader>v <c-w>v

"################插件安装###################

"手动插件管理,在.vim目录下创建一个pack/plugins/start目录，将插件直接下载到该目录下, 并配置如下两项
"packloadall                     "加载所有的插件
"silent! helptags ALL            "为所有插件加载帮助文当


" 使用vim-plug来管理vim的插件,
" 然后在命令模式下输入
" 1. PlugInstall进行插件的安装
" 2. PlugUpdate进行更新
" 3. PlugClean进行插件的清除
call plug#begin()
Plug 'scrooloose/nerdtree'                             "目录树插件
Plug 'Valloric/YouCompleteMe',{'do': './install.py'}   "代码补全插件
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }     "go语言插件
"Plug 'dgryski/vim-godef'                               "go语言中跳转，输入gd进行跳转
Plug 'suan/vim-instant-markdown'                       "markdown实时预览插件
Plug 'iamcco/markdown-preview.vim'                     "markdown实时预览插件
Plug 'ctrlpvim/ctrlp.vim'                              "模糊搜索插件
Plug 'fatih/molokai'                                   "主题插件
" Vim状态栏插件，包括显示行号，列号，文件类型，文件名，以及Git状态
Plug 'vim-airline/vim-airline'
" 查看当前代码文件中的变量和函数列表的插件，
" 可以切换和跳转到代码中对应的变量和函数的位置
" 大纲式导航, Go 需要 https://github.com/jstemmer/gotags 支持
Plug 'majutsushi/tagbar'
" 有道翻译
Plug 'ianva/vim-youdao-translater'
" 显示git分支
Plug 'tpope/vim-fugitive'
call plug#end()

"###############插件配置####################

"#########NerdTree插件配置############
" 配置打开nerdtree插件的快捷键
"noremap <leader>n :NERDTree<cr>
noremap <leader>o :NERDTreeToggle<cr>

"配置当没有打开的文件时，能够自动关闭NerdTree窗口
autocmd bufenter * if (winnr("$") == 1 && exists ("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" airline 配置
" 状态栏显示git分支信息
let g:airline#extensions#branch#enabled = 1
