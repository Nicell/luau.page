local net = require("@lute/net")
local fs = require("@lute/fs")
local process = require("@lute/process")

local server = net.serve(function()
	return fs.readfiletostring("dist/index.html")
end)

print(`Serving on http://{server.hostname}:{server.port}`)

process.run({ "echo site/init.luau | entr lute site/build.luau &" }, { shell = true })
