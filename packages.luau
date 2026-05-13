export type Visibility = "public" | "private"

export type Package = {
	name: string,
	description: string?,
	source: string,
	sourceKind: string,
	rev: string,
	visibility: Visibility,
}

return {
	{
		name = "flipbook-batteries",
		description = "Various modules for use with Lute",
		source = "https://github.com/flipbook-labs/flipbook-batteries",
		sourceKind = "github",
		rev = "main",
		visibility = "public",
	},
	{
		name = "pretty-print",
		description = "Pretty-printing for Luau values",
		source = "https://github.com/afujiwara-roblox/pretty-print",
		sourceKind = "github",
		rev = "main",
		visibility = "public",
	},
	{
		name = "base64",
		description = "Base64 encode and decode",
		source = "https://github.com/afujiwara-roblox/base64",
		sourceKind = "github",
		rev = "main",
		visibility = "public",
	},
	{
		name = "toml",
		description = "TOML parser",
		source = "https://github.com/afujiwara-roblox/toml",
		sourceKind = "github",
		rev = "main",
		visibility = "public",
	},
	{
		name = "vendor-integrations",
		description = "Roblox-internal vendor integrations",
		source = "https://github.com/Roblox/vendor-integrations",
		sourceKind = "github",
		rev = "main",
		visibility = "private",
	},
} :: { Package }
