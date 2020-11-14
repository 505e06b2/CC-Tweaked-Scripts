local args = {...}

for _, filename in ipairs(args) do
	local f, error = io.open(shell.resolve(filename))
	if f then
		print(f:read("*all"))
	else
		term.setTextColor(colours.red)
		print(error)
		term.setTextColor(colours.white)
	end
end
