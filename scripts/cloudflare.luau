local process = require("@lute/process")
local net = require("@lute/net")
local json = require("./json")

local domain = "luau.page"

local headers = {
	["X-Auth-Email"] = process.env.CLOUDFLARE_EMAIL,
	["X-Auth-Key"] = process.env.CLOUDFLARE_API_KEY,
	["Content-Type"] = "application/json",
}

local batch = {
	deletes = {},
	puts = {},
	posts = {},
}

local zoneId = process.env.CLOUDFLARE_ZONE_ID

type Record = {
	id: string,
}

local function qualifiedName(name: string): string
	if name == "" then
		return domain
	end
	return `{name}.{domain}`
end

local function getRecord(name: string): Record?
	local response = net.request(
		`https://api.cloudflare.com/client/v4/zones/${zoneId}/dns_records?type=CNAME&name=exact:{qualifiedName(name)}`,
		{
			method = "GET",
			headers = headers,
		}
	)
	local data = json.parse(response.body)
	if data.success and #data.result > 0 then
		return data.result[1]
	end
	error(`Failed to get record for {name}: {data.errors[1].message}`)
end

local function addRecord(name: string, content: string)
	table.insert(batch.posts, {
		type = "CNAME",
		name = qualifiedName(name),
		content = content,
		proxied = true,
	})
end

local function updateRecord(name: string, content: string)
	local record = getRecord(name)
	if record == nil then
		print("Record not found for", name)
		return
	end
	table.insert(batch.puts, {
		id = record.id,
		type = "CNAME",
		name = qualifiedName(name),
		content = content,
		proxied = true,
	})
end

local function deleteRecord(name: string)
	local record = getRecord(name)
	if record == nil then
		print("Record not found for", name)
		return
	end
	table.insert(batch.deletes, record.id)
end

local function sendBatch()
	if #batch.deletes == 0 and #batch.puts == 0 and #batch.posts == 0 then
		print("No changes to send.")
		return
	end

	local res = net.request(`https://api.cloudflare.com/client/v4/zones/${zoneId}/dns_records/batch`, {
		method = "POST",
		headers = headers,
		body = json.stringify(batch),
	})

	local data = json.parse(res.body)

	if not res.ok then
		for _, error in data.errors do
			print(`Error: {error.code} - {error.message} {error.documentation_url}`)
		end
		error("Failed to send batch request: " .. res.status)
	end

	print(
		`Successfully deleted {#data.results.deletes} records, updated {#data.results.puts} records, and added {#data.results.posts} records.`
	)
end

return {
	addRecord = addRecord,
	updateRecord = updateRecord,
	deleteRecord = deleteRecord,
	sendBatch = sendBatch,
}
