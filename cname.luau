export type Entry = { content: string, proxied: boolean }
export type Entries = { [string]: Entry | string }

local cname: Entries = {
	-- ["project"] = "user.github.io", (project.luau.page CNAME record for user.github.io/project)
	[""] = "nicell.github.io",
	["discord"] = "discordluau-docs.devcomp.workers.dev",
	["hermes"] = "froststarinteractive.github.io",
	["lightborn"] = "lightborn-lua.github.io",
	["lynx"] = "lynx-luau.pages.dev",
	["purse"] = "ryanlua.github.io",
	["react"] = "jsdotlua.github.io",
	["rocket"] = "teamfireworks.github.io",
	["satchel"] = "ryanlua.github.io",
	["typeforge"] = "typeforge-luau.github.io",
	["ui-labs"] = "pepeeltoro41.github.io",
}

return cname
