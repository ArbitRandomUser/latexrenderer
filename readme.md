## Whatisit ?
A way to have Latex rendered inside nvim 

## Example
![fig](https://user-images.githubusercontent.com/58146965/224890491-c4fbb91e-f366-4790-994d-87bf51bba7ee.png)


## Requirements
* Requires [hologram.nvim](https://github.com/edluffy/hologram.nvim) setup.
* Only works in [kitty](https://sw.kovidgoyal.net/kitty/)
* You must have texlive with `dvipng` binary on your system.
  if you're on Arch , [texlive-bin](https://archlinux.org/packages/extra/x86_64/texlive-bin/) should suffice
* Only works on linux (ymmv on mac , and erm Windows)

## How to use ?

### Install
It's fairly bairbones as of now , 
copy latexrenderer.lua into your computer and load it 
with `luafile /path/to/latexrenderer.lua` in your init.vim
i'll (hopefully) make this a plugin someday , but for now i'm mostly trying
out things for myself.

### Render all math
If succesfully loaded you should have two commands 
`RenderLatex <size>` , which will scan through your buffer,
treating everything between pairs of `$$` as Latex and render it below that line ( does not support inline math), `<size>` specifies the size of the png to render

### Render math at cursor
If the cursor is at an equation you can render the current equation only with `RenderLatexAtCursor <size>`. 

### Remove all renderings
`RemoveLatex` will remove the rendered pngs

## Bugs
For some reason the math cant be the first or the last line :( ,

## Misc
Colors are hardcoded (for fg of gruvbox dark) , you can change it in the line (`-fg 'cmyk 0.00 0.04 0.21 0.02'`) where dvipng is called.
