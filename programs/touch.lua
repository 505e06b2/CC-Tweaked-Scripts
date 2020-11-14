local args = {...}

if #args < 1 then
	print("Usage: touch [filenames]")
	return
end

for _, filename in ipairs(args) do
	io.open(shell.resolve(filename), "w"):close()
end
