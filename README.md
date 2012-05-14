# runfile

I was sick of adding `<Leader>r` mappings to all the various file types 
I work in. There should be a single function/mapping that automagically 
runs the correct command using some simple rules based on the file name 
and type.

It should do the Right Thing most of the time and I should be able to 
easily add custom rules in `.vimrc` when it doesn't.

Note: *This may already exist...*

## Installation

Use pathogen.

~~~ 
$ cd .vim/bundle
$ git clone https://github.com/pbrisbin/vim-runfile
~~~

## Usage

~~~ 
:Run
~~~

## Rules

Checked in order, first hit wins.

~~~ 
If filename matches...      Then :Run means...
.*_spec.rb                  !rspec -c %
.*_test.rb                  !ruby -Ilib:test %

If the filetype matches...  Then :Run means...
haskell                     !runshakell %
html                        !$BROWSER %',
python                      !python %',
ruby                        !ruby -Ilib %',
sh                          !/bin/sh %'
~~~

## Extending

Before looking at the above, runfile will check for user supplied 
mappings of each name and type. The order is user-by-name, 
default-by-name, user-by-type, default-by-type.

### Example

~~~ { .vim }
let g:runfile_by_name = {
    \ 'config.ru': '!rackup %',
    \ }

let g:runfile_by_type = {
    \ 'markdown': '!markdown2pdf %',
    \ 'html'    : '%!tidy',
    \ }
~~~

If you have a useful mapping, please pull request it. How to add it to 
the source should be obvious.

## Notes

1. Right now, the pattern in `_by_name` is matched against the filename, 
   not the full path. I might change that if it seems useful.

2. The filename pattern is regex, not glob.

3. The command part of the mapping can be any vim command, it need not 
   execute anything.
