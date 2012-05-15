# runfile

I was sick of adding a bunch of `<Leader>r` mappings to "run" the various 
executable or interpretable file types I work in. Why not a single 
function that automagically runs the correct command using some simple 
rules based on the file name and type?

It should do the Right Thing most of the time and I should be able to 
easily add custom additions and overrides in `.vimrc` when it doesn't.

## Installation

Use [pathogen][].

~~~ 
$ cd .vim/bundle
$ git clone https://github.com/pbrisbin/vim-runfile
~~~

[pathogen]: https://github.com/tpope/vim-pathogen

## Usage

~~~ 
:Run
~~~

## Rules

~~~ 
If filename matches...      Then :Run means...
.*_spec.rb                  !rspec -c %
.*_test.rb                  !ruby -Ilib:test %

If the filetype matches...  Then :Run means...
haskell                     !runshakell %
html                        !$BROWSER %
python                      !python %
ruby                        !ruby -Ilib %
sh                          !/bin/sh %
~~~

## Extending

If the maps `g:runfile_by_name` or `g:runfile_by_type` exist, they are 
merged into the default rules when the plugin first loads. 

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
   not the full path. I might change that if it seems limiting.

2. The filename pattern is regex, not glob.

3. The command part of the mapping can be any vim command, it need not 
   execute anything.
