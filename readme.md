## Whatisit ?
fairly bairbones as of now , 
copy latexrenderer.lua into your computer and load it 
with `luafile /path/to/latexrenderer.lua`

## Requirements
requires [hologram.nvim to work](https://github.com/edluffy/hologram.nvim),

only works in [kitty](https://sw.kovidgoyal.net/kitty/)

you must have texlive-bin with dvipng binary on your system

## How to use ?
if succesfully loaded you should have two commands 
`RenderLatex <size>` , which will scan through your buffer and
treating everything between pairs of `$$` as Latex and render it below that line ( does not support inline math), `<size>` specifies the size of the png to render

## bugs
for some reason the math cant be the first or the last line :(

## Example
