local path = shell.path()

shell.setPath(path .. ":/" .. shell.resolve("programs"))

local function completeFiles(shell, index, text, previous_text)
	return fs.complete(text, shell.dir(), true, false)
end

local function completeDirs(shell, index, text, previous_text)
	return fs.complete(text, shell.dir(), false, true)
end

shell.setCompletionFunction("programs/cat.lua", completeFiles)
shell.setCompletionFunction("programs/df.lua", completeDirs)

shell.run("bash")
shell.exit()
