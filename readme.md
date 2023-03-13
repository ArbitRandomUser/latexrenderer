## Whatisit ?
A way to have Latex rendered inside nvim 

## Example
![fig](https://user-images.githubusercontent.com/58146965/224803940-6828936b-5fde-4111-bdb6-6b9e30d17ecf.png)


## Requirements
requires [hologram.nvim to work](https://github.com/edluffy/hologram.nvim),

only works in [kitty](https://sw.kovidgoyal.net/kitty/)

you must have texlive-bin with `dvipng` binary on your system.

(also probably only works on linux)

## How to use ?
its fairly bairbones as of now , 
copy latexrenderer.lua into your computer and load it 
with `luafile /path/to/latexrenderer.lua` in your init.vim
this will probably never become a full fledged plugin.

if succesfully loaded you should have two commands 
`RenderLatex <size>` , which will scan through your buffer and
treating everything between pairs of `$$` as Latex and render it below that line ( does not support inline math), `<size>` specifies the size of the png to render

`RemoveLatex` will remove the rendered pngs

## Bugs
for some reason the math cant be the first or the last line :( ,

## Misc
Colors are hardcoded (for fg of gruvbox dark) , you can change it in the line where dvipng is called


