local fs = require("@lute/fs")
local site = require("./")

pcall(fs.mkdir, "dist")

fs.writestringtofile("dist/index.html", site())
