local cf = require("./cloudflare")
local porkbun = require("./porkbun")

local cname = require("../cname")
local success, oldCname = pcall(function()
	return require("../cname-old") :: cname.Entries
end)

if not success then
	print("No old cname file found, creating a new one.")
	oldCname = {}
end

local function intoEntry(content: string | cname.Entry): cname.Entry
	if typeof(content) == "string" then
		-- unstructured CNAME content, always proxied
		return { content = content, proxied = true }
	end

	-- structured entry
	return content
end

local delete = table.clone(oldCname)
local add = {}
local update = {}

for name, content in cname do
	local entry = intoEntry(content)

	if oldCname[name] == nil then
		add[name] = entry -- net new
	else
		delete[name] = nil -- exists in new, not deleted

		local oldEntry = intoEntry(oldCname[name])
		if oldEntry.content ~= entry.content or oldEntry.proxied ~= entry.proxied then
			update[name] = entry -- entry changed
		end
	end
end

for name, entry in add do
	print("add", name)
	-- cf.addRecord(name, entry.content, entry.proxied)
	porkbun.addRecord(name, entry.content)
end

for name, entry in update do
	print("update", name)
	-- cf.updateRecord(name, entry.content, entry.proxied)
	porkbun.updateRecord(name, entry.content)
end

for name, _ in delete do
	print("delete", name)
	-- cf.deleteRecord(name)
	porkbun.deleteRecord(name)
end

-- cf.sendBatch()
porkbun.printSummary()
