-- see https://www.lua.org/gems/lpg113.pdf
function try(f, on_fail, fallback)
  local success, result = pcall(f)
  if success then
    return result
  else
    if on_fail ~= nil then
      on_fail(result)
    end
    return fallback
  end
end
