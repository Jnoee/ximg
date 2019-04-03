local M = {}
local ParamUtils = require 'ParamUtils'

function M.convert(...)
  local args = ParamUtils.unpack(
    {...},
    {arg='input',     type='string',   help='输入图片',   req=true},
    {arg='output',    type='string',   help='输出图片',   req=true},
    {arg='resize',    type='string',   help='缩放比例'},
    {arg='crop',      type='string',   help='裁剪参数'},
    {arg='rotate',    type='number',   help='旋转角度'},
    {arg='flip',      type='boolean',  help='垂直翻转'},
    {arg='flop',      type='boolean',  help='水平翻转'},
    {arg='quality',   type='number',   help='图片质量 (0 到 100)', default=90},
    {arg='benchmark', type='boolean',  help='基准参数', default=false},
    {arg='text',      type='string',   help='文字水印内容'},
    {arg='font',      type='string',   help='文字水印字体'},
    {arg='fontsize',  type='number',   help='文字水印字号'},
    {arg='color',     type='string',   help='文字水印颜色'}
  )

  local options = {}
  for cmd, val in pairs(args) do
    if cmd == 'resize' then
      table.insert(options, '-resize ' .. val)
    elseif cmd == 'crop' then
      table.insert(options, '-crop ' .. val)
    elseif cmd == 'rotate' then
      table.insert(options, '-rotate ' .. val)
    elseif cmd == 'quality' then
      table.insert(options, '-quality ' .. val)
    elseif cmd == 'text' and val then
      table.insert(options, '-draw "text 100,100 ' .. val .. '"')
    elseif cmd == 'color' and val then
      table.insert(options, '-fill ' .. val)
    elseif cmd == 'font' and val then
      table.insert(options, '-font ' .. val)
    elseif cmd == 'fontsize' and val then
      table.insert(options, '-pointsize ' .. val)
    elseif cmd == 'verbose' and val then
      table.insert(options, '-verbose')
    elseif cmd == 'flip' and val then
      table.insert(options, '-flip')
    elseif cmd == 'flop' and val then
      table.insert(options, '-flop')
    end
  end

  table.insert(options, '+profile "*"')
  table.insert(options, args.input)
  table.insert(options, args.output)

  local cmd
  if args.benchmark then
    cmd = 'gm benchmark convert '
  else
    cmd = 'gm convert '
  end
  cmd = cmd .. table.concat(options, ' ')
  os.execute(cmd)
end

return M
