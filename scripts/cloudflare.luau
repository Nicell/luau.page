local process = require("@std/process")
local net = require("@std/net")
local json = require("@std/json")

local domain = "luau.page"

local headers = {
	["Authorization"] = `Bearer {process.env.CLOUDFLARE_API_KEY}`,
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
		`https://api.cloudflare.com/client/v4/zones/{zoneId}/dns_records?type=CNAME&name.exact={qualifiedName(name)}`,
		{
			method = "GET",
			headers = headers,
		}
	)
	local data = json.asObject(json.deserialize(response.body))
	assert(data, "Expected JSON object in response")
	if data.success then
		local result = json.asArray(data.result)
		assert(result, "Expected result array in response")
		if #result > 0 then
			return result[1]
		end
	end
	local errors = json.asArray(data.errors)
	assert(errors, "Expected errors array in response")
	assert(#errors > 0, "Expected at least one error in errors array")
	error(`Failed to get record for {name}: {errors[1].message}`)
end

local function addRecord(name: string, content: string, proxy: boolean)
	table.insert(batch.posts, {
		type = "CNAME",
		name = qualifiedName(name),
		content = content,
		proxied = proxy,
	})
end

local function updateRecord(name: string, content: string, proxy: boolean)
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
		proxied = proxy,
	})
end

local function deleteRecord(name: string)
	local record = getRecord(name)
	if record == nil then
		print("Record not found for", name)
		return
	end
	table.insert(batch.deletes, { id = record.id })
end

local function sendBatch()
	if #batch.deletes == 0 and #batch.puts == 0 and #batch.posts == 0 then
		print("No Cloudflare changes to send.")
		return
	end

	local res = net.request(`https://api.cloudflare.com/client/v4/zones/{zoneId}/dns_records/batch`, {
		method = "POST",
		headers = headers,
		body = json.serialize(batch),
	})

	local data = json.asObject(json.deserialize(res.body))

	if not res.ok and data then
		local errors = json.asArray(data.errors)
		assert(errors, "Expected errors array in response")
		for _, err in errors do
			local error = json.asObject(err)
			assert(error, "Expected error object in errors array")
			print(`Error: {error.code} - {error.message} {error.documentation_url or ""}`)
		end
		error("Failed to send batch request: " .. res.status)
	end

	print(
		`Cloudflare: successfully deleted {#batch.deletes} records, updated {#batch.puts} records, and added {#batch.posts} records.`
	)
end

return {
	addRecord = addRecord,
	updateRecord = updateRecord,
	deleteRecord = deleteRecord,
	sendBatch = sendBatch,
}
