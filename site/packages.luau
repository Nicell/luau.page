local h = require("./htmluau/src")
local layout = require("./layout")
local packages = require("../packages")

type Package = packages.Package

local CHIP_BASE =
	"display: inline-block; font-size: 0.75em; padding: 0.1em 0.55em; border-radius: 999px; margin-left: 0.5em; vertical-align: middle; border: 1px solid var(--pico-muted-border-color);"
local CHIP_PRIVATE = CHIP_BASE .. " background: var(--pico-mark-background-color); color: var(--pico-mark-color);"
local CARD_PRIVATE = "opacity: 0.85;"

local function snippetKey(name: string): string
	if string.match(name, "^[%a_][%w_]*$") then
		return name
	end
	return `["{name}"]`
end

local function loomSnippet(pkg: Package): string
	return string.format(
		'%s = { rev = "%s", sourceKind = "%s", source = "%s" },',
		snippetKey(pkg.name),
		pkg.rev,
		pkg.sourceKind,
		pkg.source
	)
end

local function packageCard(pkg: Package)
	local isPrivate = pkg.visibility == "private"

	local chip = h.span({ style = if isPrivate then CHIP_PRIVATE else CHIP_BASE }) {
		if isPrivate then "Private (Roblox-only)" else "Public",
	}

	local header = h.header() {
		h.strong() {
			pkg.name,
		},
		chip,
	}

	local sourceLine
	if isPrivate then
		sourceLine = h.p() {
			h.a({ href = pkg.source }) {
				pkg.source,
			},
			h.br(),
			h.small() {
				"Requires Roblox GitHub access.",
			},
		}
	else
		sourceLine = h.p() {
			h.a({ href = pkg.source }) {
				pkg.source,
			},
		}
	end

	local children = { header }

	if pkg.description then
		table.insert(children, h.p() { pkg.description })
	end

	table.insert(children, sourceLine)

	table.insert(
		children,
		h.details() {
			h.summary() {
				"Loom dependency snippet",
			},
			h.pre() {
				h.code() {
					loomSnippet(pkg),
				},
			},
		}
	)

	local articleProps = if isPrivate then { style = CARD_PRIVATE } else nil
	return h.article(articleProps)(children)
end

local cards = {}
local publicCount, privateCount = 0, 0
for _, pkg in packages do
	table.insert(cards, packageCard(pkg))
	if pkg.visibility == "private" then
		privateCount += 1
	else
		publicCount += 1
	end
end

local gridStyle = "display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 1rem;"

return layout({
	title = "Loom Packages — Luau.Page",
	description = "Directory of community LPM / Loom packages for Lute",
	body = {
		h.header() {
			h.h1() {
				"Loom Packages",
			},
			h.p() {
				"A directory of ",
				h.a({ href = "https://github.com/luau-lang/lute" }) {
					"Lute",
				},
				" packages installable with ",
				h.a({ href = "https://github.com/luau-lang/lute/tree/main/tools/loom" }) {
					"Loom",
				},
				", the package manager (",
				h.code() {
					"lute pkg install",
				},
				").",
			},
		},
		h.main() {
			h.section() {
				h.p() {
					`Listing `,
					h.strong() { #packages },
					` packages (`,
					publicCount,
					` public, `,
					privateCount,
					` Roblox-only).`,
				},
				h.div({ style = gridStyle })(cards),
			},
			h.section() {
				h.h2() {
					"Getting started",
				},
				h.p() {
					"New to Loom? Check out ",
					h.a({ href = "https://github.com/afujiwara-roblox/loom-demo" }) {
						"loom-demo",
					},
					" for a minimal project template.",
				},
				h.p() {
					"Add a package to your project by including it in the ",
					h.code() {
						"dependencies",
					},
					" table of your ",
					h.code() {
						"loom.config.luau",
					},
					":",
				},
				h.pre() {
					h.code() {
						"return {\n"
							.. "    package = {\n"
							.. '        name = "MyProject",\n'
							.. '        version = "0.1.0",\n'
							.. "        dependencies = {\n"
							.. "            -- paste a snippet from any card above\n"
							.. "        },\n"
							.. "    },\n"
							.. "}",
					},
				},
				h.p() {
					"Then run ",
					h.code() { "lute pkg install" },
					" to fetch them.",
				},
			},
			h.section() {
				h.h2() {
					"Register a package",
				},
				h.p() {
					"This directory is community-maintained. Add a package by opening a pull request that edits the ",
					h.a({ href = "https://github.com/Nicell/luau.page/blob/main/packages.luau" }) {
						"packages.luau",
					},
					" file. Public and Roblox-internal packages are both welcome — private packages are listed with a clear badge and link to the (member-only) source repo.",
				},
			},
		},
		h.footer() {
			h.small() {
				"Built with ",
				h.a({ href = "https://github.com/Nicell/htmluau" }) {
					"HTMLuau",
				},
				" and ",
				h.a({ href = "https://picocss.com" }) {
					"Pico",
				},
			},
		},
	},
})
