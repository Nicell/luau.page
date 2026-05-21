local h = require("@self/htmluau/src")
local cname = require("./cname")

local sites = {}

for key, value in cname do
	-- Skipping root and proxied entries
	if typeof(value) == "table" or key == "" then
		continue
	end
	table.insert(sites, key)
end

table.sort(sites)

return h.html({ lang = "en" }) {
	h.head() {
		h.meta({ charset = "utf-8" }),
		h.meta({ name = "viewport", content = "width=device-width, initial-scale=1" }),
		h.meta({ name = "color-scheme", content = "dark light" }),
		h.title() { "Luau.Page" },
		h.meta({ name = "description", content = "Free custom subdomains for the Luau community" }),
		h.link({
			rel = "icon",
			href = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAGFBMVEUAov4Aov4Aof4Aov7l8/6l0v5ctP4Fof7s4QukAAAABHRSTlMBRY/MU7dEywAAALZJREFUeNqNk0EOwyAMBGvs3f3/j1sXWkKDK+biQ0YwisXjFPdm/76bJL0cq4VBdVBTp5RcSS2ZbqxJTQVe3QBwEfRLJJRakcCPYEUCIqkTugCpVQkEqoQJJdn5XwB1Y7khtoJ9BYR2zEUAkkBxmzBuYOQkuEnIbwJyAgFxSWgpAATSec8QMRM8ZYIIBIGUIewW0c9g9JkJA7N2lSKTx6on00nrsupC4txkLdWPzNxrYR7kp8/+CUlvDvtDdoJIAAAAAElFTkSuQmCC",
		}),
		h.link({
			rel = "stylesheet",
			href = "https://cdn.jsdelivr.net/npm/@picocss/pico@2.1.1/css/pico.classless.min.css",
		}),
	},
	h.body() {
		h.header() {
			h.h1() { "Luau.Page" },
			h.p() {
				"Free custom subdomains for the Luau community.",
			},
		},
		h.main() {
			h.p() {
				"Currently serving ",
				h.strong() { #sites },
				" projects.",
			},
			h.div({ style = "display: flex; flex-wrap: wrap; gap: 10px;" }) {
				h.map(sites, function(site)
					local url = `http://{site}.luau.page`
					return h.article() {
						h.a({ href = url }) { site },
					}
				end),
			},
			h.h2() { "Get Started" },
			h.ol() {
				h.li() {
					"Create a website for your Luau project. Host it on GitHub Pages, Netlify, or Vercel.",
				},
				h.li() {
					"Open a pull request to add your subdomain to ",
					h.a({ href = "https://github.com/Nicell/luau.page/blob/main/cname.luau" }) {
						"cname.luau",
					},
					".",
				},
				h.li() {
					"Once merged, configure the custom domain in your hosting provider's settings.",
				},
			},
			h.p() {
				h.a({ href = "https://github.com/Nicell/luau.page", role = "button" }) {
					"Get Your Subdomain \u{2192}",
				},
			},
		},
		h.footer() {
			h.small() {
				"Built with ",
				h.a({ href = "https://github.com/Nicell/htmluau" }) { "HTMLuau" },
				" and ",
				h.a({ href = "https://picocss.com" }) { "Pico" },
			},
		},
	},
}
