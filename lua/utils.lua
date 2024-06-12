-- see https://www.lua.org/gems/lpg113.pdf
function try(f, catch_f)
	local status, exception = pcall(f)
	if not status then
		catch_f(exception)
	end
end
