local gm = require 'GraphicsMagick'
local FileUtils = require 'FileUtils'
local UrlUtils = require 'UrlUtils'

local inImg = ngx.var.img_in
local imgName = ngx.var.img_name
local imgExt = ngx.var.img_ext
local imgDir = FileUtils.getDir(ngx.var.uri)
local imgUri = imgDir .. "/" .. imgName .. "." .. imgExt
local toImg = ngx.var.img_dir .. imgUri

ngx.log(ngx.ERR, string.format('input: %s', inImg))
ngx.log(ngx.ERR, string.format('imgDir: %s', imgDir))
ngx.log(ngx.ERR, string.format('imgUri: %s', imgUri))
ngx.log(ngx.ERR, string.format('output: %s', toImg))

function flushImg(imgFile)
  local file, err = io.open(imgFile, "r")
  if not file then
    ngx.log(ngx.ERR, "open file error:", err)
    ngx.exit(ngx.HTTP_SERVICE_UNAVAILABLE)
  end

  local data
  ngx.header["Content-Type"] = "image/" .. FileUtils.getExt(imgFile)
  while true do
    data = file:read(1024)
    if nil == data then
      break
    end
    ngx.print(data)
    ngx.flush(true)
  end
  ngx.eof()
  file:close()
end

if FileUtils.exists(toImg) then
  flushImg(toImg)
else
  local toImgDir = FileUtils.getDir(toImg)
  if not FileUtils.isDir(toImgDir) then
    os.execute("mkdir -p " .. toImgDir)
  end

  if (FileUtils.exists(inImg)) then
    local params = ngx.req.get_uri_args()
    params.input = inImg
    params.output = toImg
    gm.convert(params)
    flushImg(toImg)
  else
    ngx.exit(ngx.HTTP_NOT_FOUND);
  end
end
