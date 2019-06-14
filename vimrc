map <Space> <Leader>

let g:netrw_liststyle = 1
autocmd CursorHold,CursorHoldI * update
set clipboard=unnamed
command Lightm :silent exec "!source ~/mintty-colors-solarized/sol.light" | redraw!
command Darkm :silent exec "!source ~/mintty-colors-solarized/sol.dark" | redraw!
set t_Co=256
"colors zenburn
"syntax enable
"set background=dark
"colorscheme solarized

set nocompatible "choose no compatibility with legacy vi
syntax enable
set encoding=utf-8
set showcmd                     " display incomplete commands
filetype plugin indent on       " load file type plugins + indentation

"" Whitespace
"set nowrap                      " don't wrap lines
set tabstop=4 shiftwidth=4      " a tab is two spaces (or set this to 4)
set softtabstop=4
set expandtab                   " use spaces, not tabs (optional)
set backspace=indent,eol,start  " backspace through everything in insert mode

"" Searching
set hlsearch                    " highlight matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter

inoremap jk <Esc>
inoremap kj <Esc>
inoremap jj <Esc>
set undofile
" nnoremap ; :


map <F4> :Goyo!<CR>:TogglePencil<CR>:colo seoul256<CR>
augroup pencil
  autocmd!
"  autocmd FileType markdown,mkd call pencil#init()
  autocmd FileType markdown,mkd :PencilSoft
  autocmd FileType markdown,mkd :colo seoul256 
  autocmd FileType markdown,mkd :Goyo
augroup END
map <leader>f :Goyo <bar> highlight StatusLineNC ctermfg=white<CR>
" https://github.com/junegunn/goyo.vim/issues/134https://github.com/junegunn/goyo.vim/issues/134
"https://github.com/junegunn/goyo.vim/issues/59
" https://github.com/junegunn/goyo.vim/issues/71

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <leader>w <C-w>v<C-w>l
nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>
noremap <silent> <c-_> :let @/ = ""<CR>

au FocusLost * :wa
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
"    \ set wrap |
    \ set fileformat=unix

set number
set splitbelow
set splitright

nnoremap <buffer> <F9> :exec '!python' shellescape(@%, 1)<cr>

" Bind F5 to save file if modified and execute python script in a buffer.
nnoremap <silent> <F5> :call SaveAndExecutePython()<CR><C-w>k
vnoremap <silent> <F5> :<C-u>call SaveAndExecutePython()<CR>

function! SaveAndExecutePython()
    " SOURCE [reusable window]: https://github.com/fatih/vim-go/blob/master/autoload/go/ui.vim

    " save and reload current file
    silent execute "update | edit"

    " get file path of current file
    let s:current_buffer_file_path = expand("%")

    let s:output_buffer_name = "Python"
    let s:output_buffer_filetype = "output"

    " reuse existing buffer window if it exists otherwise create a new one
    if !exists("s:buf_nr") || !bufexists(s:buf_nr)
        silent execute 'botright new ' . s:output_buffer_name
        let s:buf_nr = bufnr('%')
    elseif bufwinnr(s:buf_nr) == -1
        silent execute 'botright new'
        silent execute s:buf_nr . 'buffer'
    elseif bufwinnr(s:buf_nr) != bufwinnr('%')
        silent execute bufwinnr(s:buf_nr) . 'wincmd w'
    endif

    silent execute "setlocal filetype=" . s:output_buffer_filetype
    setlocal bufhidden=delete
    setlocal buftype=nofile
    setlocal noswapfile
    setlocal nobuflisted
    setlocal winfixheight
    setlocal cursorline " make it easy to distinguish
    setlocal nonumber
    setlocal norelativenumber
    setlocal showbreak=""

    " clear the buffer
    setlocal noreadonly
    setlocal modifiable
    %delete _

    " add the console output
    silent execute ".!python " . shellescape(s:current_buffer_file_path, 1)

    " resize window to content length
    " Note: This is annoying because if you print a lot of lines then your code buffer is forced to a height of one line every time you run this function.
    "       However without this line the buffer starts off as a default size and if you resize the buffer then it keeps that custom size after repeated runs of this function.
    "       But if you close the output buffer then it returns to using the default size when its recreated
    execute 'resize' . line('$')

    " make the buffer non modifiable
    setlocal readonly
    setlocal nomodifiable
endfunction

"autocmd BufWinLeave *.* mkviewautocmd BufWinEnter *.* silent loadview "preserves code folds across saving and re-opening, from https://www.freecodecamp.org/news/learn-linux-vim-basic-features-19134461ab85/?gi=98085b19ac53
