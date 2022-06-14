" basic text editor settings
" plugin settings
" coc and coc example settings
" language specific settings

" ===========================================================
" basic text editor settings

set tabstop=4 " show existing tab with 4 spaces width
set shiftwidth=4 " when indenting with '>', use 4 spaces width
set expandtab " On pressing tab, insert 4 spaces
nnoremap <space> i<space><Esc>r
imap jj <Esc>
set backspace=indent,eol,start
set t_Co=256
set hidden

nmap dt :call Detrailing()<CR>
function! Detrailing()
    execute '%s/ *$//g'
endfunction

" Swap the word the cursor is on with the next word (which can be on a
" newline, and punctuation is "skipped"):
nmap <silent> gw "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><C-o>:noh<CR>

nnoremap <C-w><C-w> <C-w>c

" ===========================================================
" plugin settings

filetype plugin indent on
" install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    augroup installgroup
        autocmd!
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    augroup END
endif

" plugins managed by vim-plug
call plug#begin('~/.vim/plugged')
    Plug 'neoclide/coc.nvim', {'branch': 'release'},
    Plug 'vim-airline/vim-airline',
    Plug 'vim-airline/vim-airline-themes',
    Plug 'airblade/vim-gitgutter',
    Plug 'tpope/vim-fugitive',
    Plug 'preservim/nerdcommenter',
    Plug 'flazz/vim-colorschemes',
    "Plug 'flebel/vim-mypy', { 'for': 'python', 'branch': 'bugfix/fast_parser_is_default_and_only_parser' }
    "Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' },
    Plug 'Yggdroot/indentLine',
    "Plug 'chr4/nginx.vim',
    Plug 'spacewander/openresty-vim',
    Plug 'preservim/nerdtree'
call plug#end()

" nerdcommenter
let g:NERDCreateDefaultMappings = 0
let g:NERDDefaultAlign = 'left'
xmap <leader>/ <plug>NERDCommenterToggle
nmap <leader>/ <plug>NERDCommenterToggle

" colorschemes provided by plugins
colorscheme gruvbox
set background=dark
" autocmd ColorScheme * highlight CocHighlightText ctermbg=Red  guibg=#ff0000
let g:airline_theme='simple'

" indentline
let g:indentLine_enabled = 0

" openresty-vim
augroup nginx
    autocmd!
    autocmd BufRead,BufNewFile nginx.conf set filetype=nginx
augroup end

" ===========================================================
" coc and coc example settings

let g:coc_global_extensions = [
            \'coc-sh',
            \'coc-go',
            \'coc-pyright',
            \'coc-json',
            \'coc-highlight'
            \]

" Set internal encoding of vim, not needed on neovim, since coc.nvim using some
" unicode characters in the file autoload/float.vim
set encoding=utf-8

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
    else
        execute '!' . &keywordprg . " " . expand('<cword>')
    endif
endfunction

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format)

augroup cocgroup
    autocmd!
    " Setup formatexpr specified filetype(s).
    " autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')

    " Update signature help on jump placeholder.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    " Highlight the symbol and its references when holding the cursor.
    autocmd CursorHold * silent call CocActionAsync('highlight')
augroup end

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR :silent call CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}


" ===========================================================
" language specific settings

" python
augroup pythongroup
    autocmd!
    autocmd FileType python let b:coc_root_patterns = [
                \'.git',
                \'.env',
                \'venv',
                \'.venv',
                \'setup.cfg',
                \'setup.py',
                \'pyproject.toml',
                \'pyrightconfig.json'
                \]
    autocmd FileType python let g:indentLine_enabled = 1
augroup end

" go
augroup gogroup
    autocmd!
    autocmd BufWritePre *.go :call CocAction('format')
    autocmd FileType go set expandtab!
    autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')
    autocmd FileType go set list lcs=tab:\|\ " a space here
augroup end

" jsx, tsx
augroup js
    autocmd!
    autocmd FileType typescriptreact set shiftwidth=2
    autocmd FileType javascriptreact set shiftwidth=2
augroup end
