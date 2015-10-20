"============================================================================
" File:        runfile.vim
" Description: An attempt at a uniform run command that can be called
"              from any file which does the Right Thing based on sane
"              file name/type rules as well as any custom behavior you
"              place in your vimrc.
" Maintainer:  Patrick Brisbin <pbrisbin@gmail.com>
" Version:     0.0.1
" Last Change: 29 Aug 2014
" License:     MIT
"
"============================================================================
if exists("g:loaded_runfile_plugin")
  finish
endif
let g:loaded_runfile_plugin = 1

if ! exists("g:runfile_debug")
  let g:runfile_debug = 0
endif

function s:Debug(message)
  if g:runfile_debug
    echom a:message
  endif
endfunction

command Run call s:Runfile()

let s:default_by_name = { }
let s:default_by_type = {
  \ 'cram'    : '!cram %',
  \ 'cucumber': '!cucumber %',
  \ 'go'      : '!go run %',
  \ 'haskell' : '!runhaskell %',
  \ 'html'    : '!$BROWSER %',
  \ 'python'  : '!python %',
  \ 'ruby'    : '!ruby -Ilib %',
  \ 'sh'      : '!/bin/sh %'
  \ }

if exists("g:runfile_by_name")
  let s:default_by_name =
    \ extend(s:default_by_name, g:runfile_by_name)
endif

if exists("g:runfile_by_type")
  let s:default_by_type =
    \ extend(s:default_by_type, g:runfile_by_type)
endif

function s:FileExecutable(fname)
  call system("test -x " . shellescape(a:fname))
  return !v:shell_error
endfunction

function s:Runfile()
  let fname = expand('%:p')

  call s:Debug("filename: ".fname)

  if s:FileExecutable(fname)
    call s:Debug("file is executable")
    call s:Debug("execute: !".fname)
    execute '!'.fname
    return
  endif

  for [pattern, action] in items(s:default_by_name)
    if fname =~ pattern
      call s:Debug("name matched ".pattern)
      call s:Debug("execute: ".action)
      execute action
      return
    endif
  endfor

  for [type, action] in items(s:default_by_type)
    if &ft == type
      call s:Debug("type matched ".type)
      call s:Debug("execute: ".action)
      execute action
      return
    endif
  endfor

  " Special case for vimscript. If the source were to occur via execute, weird
  " things tend to happen so we have to handle this outside of the type mapping.
  if &ft == 'vim'
    call s:Debug("type is vim")
    call s:Debug("execute: source ".fname)
    source fname
    return
  endif

  echo 'runfile: No match for this name or type'
endfunction
