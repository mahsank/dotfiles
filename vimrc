" vimrc file - Last updated 2022-08-30
set secure
set nocompatible	" be iMproved, required
filetype off	" required
" vim-plug configuration startup

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" A tree explorer plugin for vim
Plug 'scrooloose/nerdtree'
map <C-n> :NERDTreeToggle<CR>

" auto-completion for quotes, parens, brackets etc.
Plug 'raimondi/delimitmate'
let delimitMate_expand_cr = 1

" rectify the code folding
Plug 'tmhedberg/SimpylFold'
let g:SimplyFold_docstring_preview = 1

" display indentation levels with thin vertical lines
Plug 'yggdroot/indentline'
let g:indentLine_color_tty_light = 7 " (default: 4)
let g:indentLine_color_tty_dark = 1 " (default: 2)

" A general-purpose fuzzy finder
Plug 'junegunn/fzf', {'do': { -> fzf#install() } }
nnoremap <C-p> :<C-u>FZF<CR>

" lean and mean status/tabline for vim that's light as air
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" A replacement for youcompleteme, syntastic and more
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Vim alignment plugin
Plug 'junegunn/vim-easy-align'
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

"Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Initialize plugin system
call plug#end()
" vim-plug configuration end

" coc-vim related customizations -start
" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=500

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

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

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)
" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>


" coc-vim related customizations -end

" ----------- TAB CHARACTER AND INDENT HANDLING /START/----------

" width of an actual tab character
set tabstop=8

" interpret tab as an `indent` command instead of an insert-a-tab command
set softtabstop=4

" size of an indent measured in spaces; used by commands =, > and <
set shiftwidth=4

"make the tab key (in insert mode) insert spaces instead of tab characters
set expandtab

" insert a tab character with SHIFT + TAB
:inoremap <S-Tab> <C-V><Tab>

" ----------- TAB CHARACTER AND INDENT HANDLING /END/------------


" ----------- SPELLING CHECKING /START/----------

" toggle spell checking on and off with `,s`
let mapleader = ","
nmap <silent> <leader>s :set spell!<CR>

" set the spelling language to British English
set spelllang=en_gb "spelllang can be shortened as spl

" ----------- SPELLING CHECKING /END/----------

" remove trailing whitespaces with the function below
function! TrimWhitespaces()
    let l:save = winsaveview()
    %s/\s\+$//e
    call winrestview(l:save)
endfunction
" call the function by pressing ,+w simultaneously
nmap <silent> <leader>w :call TrimWhitespaces()<CR>

" open terminal inside vim to easily compile code such as Python script
nmap <silent> <leader>t :terminal<CR>

" maximum width of text that is being inserted; a longer line will be broken
" after white space to get this width
set textwidth=120
" set colorcolumn=+1

" do smart autoindenting when starting a new line; works for C-like programs,
" but can also be used for other languages
set smartindent

" show the line number relative to the line with the cursor in front of each
" line
set relativenumber

" indicate a fast terminal connection; more characters will be sent to the
" screen for redrawing, instead of using insert/delete line commands
set ttyfast

" when a file has been detected to have been changed outside of vim and it has
" not been changed inside of vim, automatically read it again; when the file has
" been deleted this is not done
set autoread

colorscheme industry
" show line numbers
set number 
" always display the cursorline at the bottom
set cursorline laststatus=2

" switch off annoying sound or errors
set noerrorbells novisualbell

" make search act like search in modern browsers
set incsearch
" highlight search results
set hlsearch
" turn off search highlight; vim will keep highlighted matches from searches until
" we run a new one or manually stop highlighting the old search with :nohlsearch.
nnoremap <leader><leader> :nohlsearch<CR>

" show matching brackets when text indicator is over them
set showmatch
" how many tenths of a second to blink when matching brackets
set matchtime=2

" always show tab bar at the top
set showtabline=2

" make tab completion for files/buffers act like bash
set wildmenu

" enable syntax processing
syntax enable

" Move around the splits with <C-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
" Rotate two windows with CTRL+r rather than CTRL+w and r
" nnoremap <c-r> <c-w>r
" Set new vertical split on right and horizontal split below; feels more
" natural
set splitright
set splitbelow

" easily navigate the buffer with custom shortcuts
" map the buffernext command to ,n
nmap <silent> <leader>n :bnext<CR>
" map the bufferprevious command to ,b
nmap <silent> <leader>b :bprevious<CR>

" enable folding
set foldmethod=indent
set foldlevel=99
nnoremap <space> za

" compile and run c/c++ code
" let $CXXFLAGS='-Wall -g'
nnoremap <silent> <F7> :make %< <CR>

hi CursorLine cterm=NONE ctermbg=DarkMagenta ctermfg=White
hi ColorColumn ctermbg=lightgrey guibg=lightgrey
hi search ctermbg=yellow ctermfg=black guibg=red
