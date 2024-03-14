silent! iunmap <buffer> <Tab>

if exists('b:did_ftplugin_personal') | finish | endif
let b:did_ftplugin_personal = 1

nnoremap <silent><buffer> o :<c-u>call CustomListo()<cr>
nnoremap <silent><buffer> O :<c-u>call CustomListO()<cr>

function CustomListo() 
  let l:enabled = rblist#enabled()
  if l:enabled
    call rblist#disable()
  endif
  call vimwiki#u#count_exe('call vimwiki#lst#kbd_o()')

  if l:enabled
    call rblist#enable()
  endif

endfunction

function CustomListO() 
  let l:enabled = rblist#enabled()
  if l:enabled
    call rblist#disable()
  endif
  " call rblist#disable()
  call vimwiki#u#count_exe('call vimwiki#lst#kbd_O()')

  if l:enabled
    call rblist#enable()
  endif
  " call rblist#enable()

endfunction

" function! ZettelTitleSearch()
"    let g:zettel_fzf_command = "rg --column --line-number --smart-case --multiline --no-heading --color=always --regexp '^title: (.+)' --replace '$1'"
"    ZettelOpen()
"  endfunction

"  nnoremap <leader>ot :call ZettelTitleSearch()<CR>

"  function! ZettelFullSearch()
"    let g:zettel_fzf_command = "rg --column --line-number --smart-case --multiline --no-heading --color=always"
"    ZettelOpen()
"  endfunction

" nnoremap <leader>of :call ZettelFullSearch()<CR>
