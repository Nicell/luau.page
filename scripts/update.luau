local cf = require("./cloudflare")

local cname = require("../cname")
local success, oldCname = pcall(function()
	return require("../cname-old")
end)

if not success then
	print("No old cname file found, creating a new one.")
	oldCname = {}
end

local delete = table.clone(oldCname)
local add = {}
local update = {}

for name, content in cname do
	if oldCname[name] == nil then
		add[name] = content -- net new
	else
		delete[name] = nil -- exists in new, not deleted
		if oldCname[name] ~= content then
			update[name] = content -- content changed
		end
	end
end

for name, content in add do
	print("add", name)
	cf.addRecord(name, content)
end

for name, content in update do
	print("update", name)
	cf.updateRecord(name, content)
end

for name, _ in delete do
	print("delete", name)
	cf.deleteRecord(name)
end

cf.sendBatch()
