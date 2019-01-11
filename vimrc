" All system-wide defaults are set in $VIMRUNTIME/archlinux.vim (usually just
" /usr/share/vim/vimfiles/archlinux.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vimrc), since archlinux.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing archlinux.vim since it alters the value of the
" 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages.
runtime! archlinux.vim

" If you prefer the old-style vim functionalty, add 'runtime! vimrc_example.vim'
" Or better yet, read /usr/share/vim/vim80/vimrc_example.vim or the vim manual
" and configure vim to your own liking!

" do not load defaults if ~/.vimrc is missing
"let skip_defaults_vim=1
set nocompatible
set tabstop=4
set shiftwidth=4
set expandtab
set nu
set incsearch
set hlsearch
nnoremap <silent> <F2> :nohls<cr>

command WQ wq
command Wq wq
command W w
command Q q
command Qw wq
" FILETYPE SPECIFIC SETTINGS
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType yml setlocal ts=2 sts=2 sw=2 expandtab

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
  Plug 'arcticicestudio/nord-vim'
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries', 'for': 'go' }

"  if has('nvim')
"    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins', 'for': 'go' }
"  else
"    Plug 'Shougo/deoplete.nvim', { 'for': 'go' }
"    Plug 'roxma/nvim-yarp', { 'for': 'go' }
"    Plug 'roxma/vim-hug-neovim-rpc', { 'for': 'go' }
"  endif

  Plug 'scrooloose/nerdtree'
  Plug 'Xuyuanp/nerdtree-git-plugin'

call plug#end()
syntax enable
colorscheme nord
highlight Comment cterm=italic
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
""""""""""""""""""""""""""""""""""""
" NERD TREE SETTINGS AND SHORTCUTS "
""""""""""""""""""""""""""""""""""""
map <C-n> :NERDTreeToggle<CR>
" Close when only file open is vim 
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


" DEOPLETE OPTIONS
let g:deoplete#enable_at_startup = 1
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"


