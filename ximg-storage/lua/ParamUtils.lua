local M = {}

function M.unpack(args, ...)
  local defs = {...}
  local iargs = {}
  for i = 1, select('#', ...) do
    iargs[defs[i].arg] = args[i]
  end

  local dargs = {}
  for i = 1, #defs do
    local def = defs[i]
    if def.req and iargs[def.arg] == nil then
      print('missing argument: ' .. def.arg)
    end
    dargs[def.arg] = iargs[def.arg]
    if dargs[def.arg] == nil and def.default then
      dargs[def.arg] = dargs[def.default]
    end
    dargs[i] = dargs[def.arg]
  end

  return unpack(dargs)
end

return M