if has('autocmd')
  " 为了可以重新执行 vimrc，开头先清除当前组的自动命令
  au!
endif

if has('gui_running')
  " 下面两行仅为占位使用；请填入你自己的字体
  set guifont=Source_Code_Pro:h14
  set guifontwide=

  " 不延迟加载菜单（需要放在下面的 source 语句之前）
  let do_syntax_sel_menu = 1
  let do_no_lazyload_menus = 1
endif

set enc=utf-8
source $VIMRUNTIME/vimrc_example.vim

" 启用 man 插件
source $VIMRUNTIME/ftplugin/man.vim

set fileencodings=ucs-bom,utf-8,gb18030,latin1
set formatoptions+=m
set keywordprg=:Man
set scrolloff=1
" 暂不使用，使用自动产生的tag放到.cache/tags/目录下
" set tags=./tags;,tags,/usr/local/etc/systags
set nobackup
set errorformat=\ %#%f(%l\\\,%c):\ %m
set number
" 配色方案
set bg=dark

if has('persistent_undo')
  set undofile
  set undodir=~/.vim/undodir
  if !isdirectory(&undodir)
    call mkdir(&undodir, 'p', 0700)
  endif
endif

if has('mouse')
  if has('gui_running') || (&term =~ 'xterm' && !has('mac'))
    set mouse=a
  else
    set mouse=nvi
  endif
endif

if !has('gui_running')
  " 设置文本菜单
  if has('wildmenu')
    set wildmenu
    set cpoptions-=<
    set wildcharm=<C-Z>
    nnoremap <F10>      :emenu <C-Z>
    inoremap <F10> <C-O>:emenu <C-Z>
  endif
endif

if has('termguicolors') &&
      \($COLORTERM == 'truecolor' || $COLORTERM == '24bit')
  set termguicolors
endif


call plug#begin('~/.vim/plugged')
  "插件  
  Plug 'junegunn/fzf', {'do': {-> fzf#install()}}
  Plug 'junegunn/fzf.vim'
  Plug 'majutsushi/tagbar'
  Plug 'mbbill/undotree'
  Plug 'preservim/nerdtree',{'on': 'NERDTreeToggle'}
  Plug 'skywind3000/asyncrun.vim'
  Plug 'tpope/vim-eunuch'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-surround'
  Plug 'yegappan/mru'
  Plug 'morhetz/gruvbox'
  Plug 'ludovicchabant/vim-gutentags'
  Plug 'mbbill/echofunc'
  Plug 'adah1972/cscope_maps.vim'
  Plug 'tpope/vim-fugitive'
  Plug 'vim-airline/vim-airline'
  Plug 'preservim/nerdcommenter'
  Plug 'mg979/vim-visual-multi'
  Plug 'frazrepo/vim-rainbow'
  Plug 'jiangmiao/auto-pairs'
  Plug 'vim-scripts/LargeFile'
  Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
  Plug 'Yggdroot/indentLine'
  Plug 'easymotion/vim-easymotion'
  Plug 'joshdick/onedark.vim'

call plug#end()

" airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#overflow_marker = '…'
let g:airline#extensions#tabline#show_tab_nr = 0

if has('eval')
" 和asynrun一起用的异步make命令
  command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
endif

if v:version >= 800
  packadd! editexisting
endif

" fzf搜索映射
nnoremap <C-P> :Files<CR> 
" ag搜索映射
nnoremap <C-G> :Ag<CR> 

" 切换窗口的键映射
nnoremap <C-Tab>   <C-W>w
inoremap <C-Tab>   <C-O><C-W>w
nnoremap <C-S-Tab> <C-W>W
inoremap <C-S-Tab> <C-O><C-W>W

" 替换光标下单词的键映射
nnoremap <Leader>v viw"0p
vnoremap <Leader>v    "0p

" 停止搜索高亮的键映射
nnoremap <silent> <F2>      :nohlsearch<CR>
inoremap <silent> <F2> <C-O>:nohlsearch<CR>

" 映射按键来快速启停构建
nnoremap <F5>  :if g:asyncrun_status != 'running'<bar>
                 \if &modifiable<bar>
                   \update<bar>
                 \endif<bar>
                 \exec 'Make'<bar>
               \else<bar>
                 \AsyncStop<bar>
               \endif<CR>

" 开关撤销树的键映射
nnoremap <F6>      :UndotreeToggle<CR>
inoremap <F6> <C-O>:UndotreeToggle<CR>

" 开关 Tagbar 插件的键映射
nnoremap <F9>      :TagbarToggle<CR>
inoremap <F9> <C-O>:TagbarToggle<CR>

" 用于 quickfix、标签和文件跳转的键映射
if !has('mac')
nnoremap <F11>   :cn<CR>
nnoremap <F12>   :cp<CR>
else
nnoremap <D-F11> :cn<CR>
nnoremap <D-F12> :cp<CR>
endif
nnoremap <M-F11> :copen<CR>
nnoremap <M-F12> :cclose<CR>
nnoremap <C-F11> :tn<CR>
nnoremap <C-F12> :tp<CR>
nnoremap <S-F11> :n<CR>
nnoremap <S-F12> :prev<CR>
set cscopequickfix=s-,c-,d-,i-,t-,e-,a-

" YCM
nnoremap <Leader>fi :YcmCompleter FixIt<CR>
nnoremap <Leader>gt :YcmCompleter GoTo<CR>
nnoremap <Leader>gd :YcmCompleter GoToDefinition<CR>
nnoremap <Leader>gh :YcmCompleter GoToDeclaration<CR>
nnoremap <Leader>gr :YcmCompleter GoToReferences<CR>

let g:ycm_use_clangd=1
let g:ycm_auto_hover = ''
let g:ycm_complete_in_comments = 1
let g:ycm_filetype_whitelist = {
      \ 'c': 1,
      \ 'cpp': 1,
      \ 'python': 1,
      \ 'vim': 1,
      \ 'sh': 1,
      \ 'zsh': 1,
      \ }
let g:ycm_goto_buffer_command = 'split-or-existing-window'
let g:ycm_key_invoke_completion = '<C-Z>'

" 精调C类语言语法加亮
let g:c_space_errors = 1
let g:c_gnu = 1
let g:c_no_cformat = 1
let g:c_no_curly_error = 1
if exists('g:c_comment_strings')
  unlet g:c_comment_strings
endif

" gutentags插件配置
" gutentags搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归 "
let g:gutentags_project_root = ['.root', '.svn', '.git', '.project']
" 所生成的数据文件的名称 "
let g:gutentags_ctags_tagfile = '.tags'
" 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录 "
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags
" 检测 ~/.cache/tags 不存在就新建 "
if !isdirectory(s:vim_tags)
   silent! call mkdir(s:vim_tags, 'p')
endif
" 配置 ctags 的参数 "
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+pxI']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

" auto-pairs 禁用按键映射
let g:AutoPairsShortcutToggle = 'π'

" LargeFile设置文件大小阈值 100MB
let g:LargeFile = 100

" HOME键自动跳转到当前行第一个非空白字符而非行首顶格
function! GoToFirstNonBlankOrFirstColumn()
  let cur_col = col('.')
  normal! ^
  if cur_col != 1 && cur_col == col('.')
    normal! 0
  endif
  return ''
endfunction

nnoremap <silent> <Home> :call GoToFirstNonBlankOrFirstColumn()<CR>
inoremap <silent> <Home> <C-R>=GoToFirstNonBlankOrFirstColumn()<CR>

" indentLine 插件分割符
let g:indentLine_color_term = 239
let g:indentLine_char_list = ['|', '¦', '┆', '┊']

" easymotion 快捷键映射
nmap ss <Plug>(easymotion-s2)

" vim启动自动运行
if has('autocmd')
  function! GnuIndent()
    setlocal cinoptions=>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1
    setlocal shiftwidth=2
    setlocal tabstop=8
  endfunction

  autocmd vimenter * ++nested colorscheme onedark
  " NERDTree
  " 在 Vim 启动时自动打开 NERDTree启动 NERDTree 并将光标放回另一个窗口中
  autocmd vimenter * NERDTree | wincmd p
  " 当剩余的窗口都不是文件编辑窗口时，自动退出vim
  autocmd BufEnter * if 0 == len(filter(range(1, winnr('$')), 'empty(getbufvar(winbufnr(v:val), "&bt"))')) | qa! | endif
  " Rainbow
  autocmd vimenter * RainbowLoad
  
  " 异步运行命令时打开 quickfix 窗口，高度为 10 行
  let g:asyncrun_open = 10

  au FileType c,cpp,cc,objc  setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=4 cinoptions=:0,g0,(0,w1 
  au FileType json        setlocal expandtab shiftwidth=2 softtabstop=2
  au FileType vim         setlocal expandtab shiftwidth=2 softtabstop=2

  au FileType help        nnoremap <buffer> q <C-W>c

  au BufRead /usr/include/*  call GnuIndent()
endif
