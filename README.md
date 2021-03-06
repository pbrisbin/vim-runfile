# runfile

I was sick of adding a bunch of `<Leader>r` mappings to "run" the 
various executable or interpretable file types I work in. Why not a 
single function that auto-magically runs the correct command using some 
simple rules based on the file name and type?

It should do the Right Thing most of the time and I should be able to 
easily customize and override in `.vimrc`.

## Installation

Use [pathogen][].

```
$ cd .vim/bundle
$ git clone https://github.com/pbrisbin/vim-runfile
```

[pathogen]: https://github.com/tpope/vim-pathogen

## Usage

```vim
:Run
```

## Default Rules

```
If file is executable...    Then :Run means...
                            !%

If the filetype matches...  Then :Run means...
cram                        !cram %
cucumber                    !cucumber %
go                          !go run %
haskell                     !runhaskell %
html                        !$BROWSER %
python                      !python %
ruby                        !ruby -Ilib %
sh                          !/bin/sh %
vim                         source %
```
## Extending

If the maps `g:runfile_by_name` or `g:runfile_by_type` exist, they are 
merged into the default rules when the plugin first loads.

### Example

```vim
let g:runfile_by_name = {
    \ 'config.ru': '!rackup %',
    \ }

let g:runfile_by_type = {
    \ 'markdown': '!markdown2pdf %',
    \ 'html'    : '%!tidy',
    \ }
```

## Notes

1. Right now, the pattern in `_by_name` is matched against the filename, 
   not the full path. I might change that if it seems limiting.

2. The filename pattern is regex, not glob.

3. The command part of the mapping can be any vim command, it need not 
   execute anything.

4. The rules are tried in key-alphabetical order, not definition order as you
   might expect or want. This is because of vim, not by design.
