"============================================================================
" File:        runfile.vim
" Description: An attempt at a uniform run command that can be called
"              from any file which does the Right Thing based on sane
"              file name/type rules as well as any custom behavior you
"              place in your vimrc.
" Maintainer:  Patrick Brisbin <pbrisbin@gmail.com>
" Version:     0.0.1
" Last Change: 14 May 2012
" License:     MIT
"
"============================================================================
if exists("g:loaded_runfile_plugin")
  finish
endif
let g:loaded_runfile_plugin = 1

command! Run call s:Runfile()

let s:default_by_name = {
  \ '.*_spec.rb'   : '!rspec -c %',
  \ '.*_test.rb'   : '!ruby -Ilib:test %'
  \ }

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
    \ extend(g:runfile_by_name, s:default_by_name, "keep")
endif

if exists("g:runfile_by_type")
  let s:default_by_type =
    \ extend(g:runfile_by_type, s:default_by_type, "keep")
endif

" Define a function that can tell me if a file is executable
function! s:FileExecutable(fname)
  execute "silent! ! test -x" a:fname
  return !v:shell_error
endfunction

function s:Runfile()
  let fname = expand('%')

  if s:FileExecutable(fname)
    exec '!./%'
    return
  endif

  for pattern in keys(s:default_by_name)
    if fname =~ pattern
      "echo s:default_by_name[pattern]
      exec s:default_by_name[pattern]
      return
    endif
  endfor

  for type in keys(s:default_by_type)
    if &ft == type
      "echo s:default_by_type[type]
      exec s:default_by_type[type]
      return
    endif
  endfor

  echo 'runfile: No match for this name or type'
endfunction
