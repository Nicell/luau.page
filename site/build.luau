local fs = require("@lute/fs")
local home = require("./")
local packages = require("./packages")

local function writeString(path: string, contents: string)
	local handle = fs.open(path, "w")
	fs.write(handle, contents)
	fs.close(handle)
end

pcall(fs.mkdir, "dist")
pcall(fs.mkdir, "dist/packages")

writeString("dist/index.html", home())
writeString("dist/packages/index.html", packages())
