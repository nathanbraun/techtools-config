let g:vim_ai_mod = {}
let g:vim_ai_mod['chat_files_path'] = expand('$NOTES_DIR')

if g:vim_ai_mod['chat_files_path'] !~ '/$'
  let g:vim_ai_mod['chat_files_path'] .= '/'
endif

let g:vim_ai_open_chat_presets = {
\  'preset_below': '10new | call vim_ai#MakeScratchWindow()',
\  'preset_tab': 'tabnew | call vim_ai#MakeScratchWindow()',
\  'preset_right': 'rightbelow 55vnew | setlocal noequalalways | setlocal winfixwidth | call vim_ai#MakeScratchWindow()',
\  'preset_persistent': 'call g:vim_ai_mod.CreatePersistentChat()'
\}

function! RandomChar()
  let l:chars = 'abcdefghijklmnopqrstuvwxyz0123456789'
  let l:index = rand() % len(l:chars)
  return l:chars[l:index]
endfunction

function! RandomFilename()
  let l:random_string = ''
  let l:i = 0
  while l:i < 4
    let l:random_string .= RandomChar()
    let l:i += 1
  endwhile
  let l:filename = l:random_string . '-ai.wiki'
  return l:filename
endfunction

function! g:vim_ai_mod.CreatePersistentChat()
  let l:filename = RandomFilename()
  let l:fullpath = g:vim_ai_mod['chat_files_path'] . l:filename

  " Create a new buffer for the .aichat file
  execute 'e ' . l:fullpath

  " Now set the filetype to trigger any filetype plugins
  setlocal filetype=aichat

  " Position cursor after the header
  " execute 'normal! 7G'
endfunction
command! AINewPersistentChat call vim_ai#AINewChatRun('persistent')

