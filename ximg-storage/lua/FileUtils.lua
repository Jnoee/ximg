local M = {}

-- 检测路径是否目录
function M.isDir(path)
  if type(path) ~= "string" then return false end
  local response = os.execute("cd " .. path)
  if response == 0 then
    return true
  end
  return false
end

-- 文件是否存在
function M.exists(filename)
  local f = io.open(filename, "r")
  if f ~= nil then io.close(f) return true else return false end
end

-- 获取文件路径
function M.getDir(filename)
  return string.match(filename, "(.+)/[^/]*%.%w+$")
end

-- 获取文件名
function M.getName(filename)
  return string.match(filename, ".+/([^/]*%.%w+)$")
end

--获取扩展名
function M.getExt(filename)
  return filename:match(".+%.(%w+)$")
end

return M
