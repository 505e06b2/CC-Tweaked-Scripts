term.clear()
term.setCursorPos(1,1)

local exit = false
local line = ""
local command_history = settings.get("bash_history", {})

local function tokenise(...)
	local line = table.concat( { ... }, " " )
	local words = {}
	local quoted = false
	for match in string.gmatch(line .. "\"", "(.-)\"") do
		if quoted then
			table.insert(words, match)
		else
			for m in string.gmatch(match, "[^ \t]+") do
				table.insert(words, m)
			end
		end
		quoted = not quoted
	end
	return words
end

while not exit do
	write(fs.getName(shell.dir()) .. " $ ")
	term.redirect(term.current())

	if settings.get("shell.autocomplete") then
		line = read(nil, command_history, shell.complete)
	else
		line = read(nil, command_history)
	end
	table.insert(command_history, line)
	settings.set("bash_history", command_history)
	settings.save()


	tokens = tokenise(line)
	if tokens[1] == "exit" then
		exit = true
	end
	shell.run(line)
end
