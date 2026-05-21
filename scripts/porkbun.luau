local process = require("@std/process")
local net = require("@std/net")
local json = require("@std/json")

local domain = "luau.page"
local apiUrl = "https://api.porkbun.com/api/json/v3"

local headers = {
	["Content-Type"] = "application/json",
}

local changes = {
	deletes = 0,
	puts = 0,
	posts = 0,
}

type Record = {
	id: string,
	name: string,
	type: string,
	content: string,
}

local function requiredEnv(name: string): string
	local value = process.env[name]
	if value == nil or value == "" then
		error(`Missing required environment variable {name}`)
	end
	return value
end

local apiKey = requiredEnv("PORKBUN_API_KEY")
local secretApiKey = requiredEnv("PORKBUN_SECRET_API_KEY")

local function authBody(extra: { [string]: any }?): { [string]: any }
	local body: { [string]: any } = {
		apikey = apiKey,
		secretapikey = secretApiKey,
	}

	if extra ~= nil then
		for key, value in extra do
			body[key] = value
		end
	end

	return body
end

local function request(path: string, body: { [string]: any }): { [string]: any }
	local response = net.request(apiUrl .. path, {
		method = "POST",
		headers = headers,
		body = json.serialize(body),
	})

	local data = json.asObject(json.deserialize(response.body))
	assert(data, "Expected JSON object in Porkbun response")

	if not response.ok or data.status ~= "SUCCESS" then
		error(`Porkbun request failed for {path}: {data.code or response.status} - {data.message or response.body}`)
	end

	return data
end

local function qualifiedName(name: string): string
	if name == "" then
		return domain
	end
	return `{name}.{domain}`
end

local function recordType(name: string): string
	if name == "" then
		return "ALIAS"
	end
	return "CNAME"
end

local recordsCache: any = nil

local function getRecords(): any
	if recordsCache ~= nil then
		return recordsCache
	end

	local data = request(`/dns/retrieve/{domain}`, authBody())
	local records = json.asArray(data.records)
	assert(records, "Expected records array in Porkbun response")

	recordsCache = records
	return records
end

local function getRecord(name: string): Record?
	local fqdn = qualifiedName(name)

	for _, record in getRecords() do
		if record.type == recordType(name) and record.name == fqdn then
			return record
		end
	end

	return nil
end

local function recordBody(name: string, content: string): { [string]: any }
	return authBody({
		type = recordType(name),
		name = name,
		content = content,
	})
end

local function addRecord(name: string, content: string)
	request(`/dns/create/{domain}`, recordBody(name, content))
	changes.posts += 1
end

local function updateRecord(name: string, content: string)
	local record = getRecord(name)
	if record == nil then
		print("Record not found for", name)
		return
	end

	request(`/dns/edit/{domain}/{record.id}`, recordBody(name, content))
	changes.puts += 1
end

local function deleteRecord(name: string)
	local record = getRecord(name)
	if record == nil then
		print("Record not found for", name)
		return
	end

	request(`/dns/delete/{domain}/{record.id}`, authBody())
	changes.deletes += 1
end

local function printSummary()
	if changes.deletes == 0 and changes.puts == 0 and changes.posts == 0 then
		print("No Porkbun changes applied.")
		return
	end

	print(
		`Porkbun: successfully deleted {changes.deletes} records, updated {changes.puts} records, and added {changes.posts} records.`
	)
end

return {
	addRecord = addRecord,
	updateRecord = updateRecord,
	deleteRecord = deleteRecord,
	printSummary = printSummary,
}
