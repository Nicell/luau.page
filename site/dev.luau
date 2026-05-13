local net = require("@lute/net")
local fs = require("@lute/fs")
local process = require("@lute/process")

local function readString(path: string): string
	local handle = fs.open(path, "r")
	local contents = fs.read(handle)
	fs.close(handle)
	return contents
end

local server = net.server.serve(function(request)
	local path = request.path or "/"
	local file = if path == "/packages" or path == "/packages/" then "dist/packages/index.html" else "dist/index.html"
	return { body = readString(file) }
end)

print(`Serving on http://{server.hostname}:{server.port}`)

process.run({
	"sh",
	"-c",
	"ls site/*.luau cname.luau packages.luau | entr lute site/build.luau &",
})
