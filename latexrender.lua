local vim = vim

function printtable(t)
  --for debug
  for k,v in pairs(t) do
    print(k,v)
  end
end

function counttable(t)
  --returns number of elements in table
  count=0
  for _ in pairs(t) do
    count=count+1
  end
  return count
end

local random = math.random
math.randomseed(os.time())
local function uuid()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end


function find_equations()
  --returns a list , every element of list is table {lno,cno} pair 
  lines = vim.api.nvim_buf_get_lines(0,0,-1,false)
  positions = {}
  -- read through all of them 
  for lno,line in pairs(lines) do
    st = 1
    while true do
      local x,y=string.find(line,"$$",st,true)
      if x==nil then break end
      table.insert(positions,{lno,x})
      st=y+1
    end
  end
  if (counttable(positions)%2)~=0 then
    print("unmatched $$")
  end
  return positions
end

function latex_topng(fnames,size)
  --renders the latex as png's  in /tmp
  latexjobids = {}
  dvijobids = {}
  for k,fname in pairs(fnames) do
    jobid = vim.fn.jobstart("latex  --interaction=nonstopmode --output-dir=/tmp --output-format=dvi LATEXFILE" .. fname, {cwd="/tmp",on_stdout = function (j,d,e) print() end,on_stderr=function (j,d,e) print() end})
    table.insert(latexjobids,jobid)
  end
  vim.fn.jobwait(latexjobids)
  for k,fname in pairs(fnames) do
    jobid = vim.fn.jobstart("dvipng -D "..tonumber(size).. " -z 9  -bg Transparent -fg 'cmyk 0.00 0.04 0.21 0.02'  -o /tmp/LATEXFILE"..fname..".png".." ".."/tmp/LATEXFILE"..fname..".dvi",{cwd="/tmp",on_stdout = function (j,d,e) print() end})
    table.insert(dvijobids,jobid)
  end
  vim.fn.jobwait(dvijobids)
end

function get_lstrings(positions)
  --gets list os strings between positions 
  --positions is a list of pairs of lno,cno  (lineno , columno)
  lstrings = {}
  for i=1,counttable(positions),2 do
    lstring = ""
    start = positions[i]
    stop = positions[i+1]
    for k,v in pairs(vim.api.nvim_buf_get_text(0,start[1]-1,start[2]+1,stop[1]-1,stop[2]-1,{nil})) do
      lstring = lstring .. v
    end
    table.insert(lstrings,lstring)
  end
  return lstrings
end
local pre = "\\documentclass[12pt]{standalone}\n \\usepackage{amsmath}\n \\usepackage{amssymb} \n \\begin{document}\n \\begin{align} "
local post = "\\end{align} \n \\end{document}"

function write_texfiles(lstrings)
  fnames = {}
  for k,v in pairs(lstrings) do
    fname = uuid()
    filehandle = io.open("/tmp/LATEXFILE"..fname, "w")
    filehandle:write(pre..v.."\n"..post)
    filehandle:close()
    table.insert(fnames,fname)
  end
  return fnames
end

local imgs = {}
function insertpngs(eqpos,fnames,size)
  findex = 1
  for i=1,counttable(eqpos),2 do
    source = "/tmp/LATEXFILE"..fnames[findex]..".png"
    buf = vim.api.nvim_get_current_buf()
    table.insert(imgs,require('hologram.image'):new(source, {}))
    imgs[findex]:display(eqpos[i+1][1], 0, buf, {})
    findex = findex+1
  end
end

function RenderLatex(opts)
  RemoveLatex()
  eqpos = find_equations()
  lstrings = get_lstrings(eqpos)
  fnames = write_texfiles(lstrings)
  latex_topng(fnames,opts.fargs[1])
  insertpngs(eqpos,fnames)
end

--function RenderLatex(opts)
--  local timer = vim.loop.new_timer()
--  timer:start(0,0,vim.schedule_wrap(renderlatex))
--end

function RemoveLatex()
  for k,img in pairs(imgs) do
    img:delete(0,{free=true})
  end
  for k,v in pairs(imgs) do
    imgs[k] = nil
  end
end

vim.api.nvim_create_user_command('RenderLatex', RenderLatex , {nargs=1, complete = function(ArgLead,CmdLine,CursorPos) 
return {"200","300"} end })

vim.api.nvim_create_user_command('RemoveLatex', RemoveLatex , {nargs=0})
