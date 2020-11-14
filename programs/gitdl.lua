local download_url = "https://raw.githubusercontent.com/%s/master/%s"

local repo = ...

if not repo or repo == "-h" then
	print("Usage: gitdl [username]/[repo]")
	return
end

repo_url = string.format("https://api.github.com/repos/%s/git/trees/master", repo)

local r, error = http.get(repo_url)
if r == nil then
	term.setTextColor(colours.red)
	print(string.format("Not able to get repo info: %s", error))
	term.setTextColor(colours.white)
	return
end

local function parseFolder(folder_path, contents)
	for _, item in ipairs(contents) do
		local disk_path = folder_path .. item["path"]

		if item["type"] == "blob" then --file
			print(string.format("Downloading %s...", disk_path))
			local r, error = http.get({url=download_url:format(repo, disk_path), binary=true})
			if r then
				local f = io.open(fs.combine(shell.dir(), disk_path), "wb")
				f:write(r.readAll())
				f:close()
			else
				print(string.format("Failed to download %s: %s", disk_path, error))
			end

		elseif item["type"] == "tree" then --folder
			print(string.format("Reading %s...", disk_path))
			fs.makeDir(fs.combine(shell.dir(), disk_path))
			local r, error = http.get(item["url"])
			if r then
				parseFolder(disk_path .. "/", textutils.unserialiseJSON(r.readAll())["tree"])
			else
				print(string.format("Failed to get folder info %s: %s", disk_path, error))
			end
		end
	end
end

parseFolder("", textutils.unserialiseJSON(r.readAll())["tree"])
