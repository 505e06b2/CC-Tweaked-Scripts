local path = ...

if path == nil then
	path = "/"
end

local amount = fs.getFreeSpace(path)
if type(amount) == "string" then
	print("Unlimited")
else
	print(math.floor(amount/1024) .. "kb")
end
