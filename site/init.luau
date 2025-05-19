local h = require("@self/htmluau/src")
local cname = require("./cname")

local siteCards = {}

for key, _ in cname do
	local isRoot = key == ""

	local url = `https://{key .. (if isRoot then "" else ".")}luau.page`
	-- Create a card for each site
	local card = h.article() {
		h.header() {
			if isRoot then "This site!" else key,
		},
		h.a({ href = url }) {
			url,
		},
	}

	table.insert(siteCards, card)
end

return h.html({ lang = "en" }) {
	h.head() {
		h.meta({ charset = "utf-8" }),
		h.meta({ name = "viewport", content = "width=device-width, initial-scale=1" }),
		h.meta({ name = "color-scheme", content = "dark light" }),
		h.title() {
			"Luau.Page",
		},
		h.meta({ name = "description", content = "Custom domains for the Luau community" }),
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
			h.h1() {
				"Luau.Page",
			},
			h.p() {
				"Custom domains for the Luau community",
			},
		},
		h.main() {
			h.section() {
				h.p() {
					"Luau.Page is currently serving",
					h.strong() {
						#siteCards,
					},
					" sites.",
				},
				h.div({ style = "display: flex; flex-direction: row; gap: 10px;" })(siteCards),
				h.p() {
					"Get your own custom domain for your Luau project.",
					"In just a few steps, you can have your own subdomain on luau.page.",
				},
				h.h2() {
					"Create a website with Luau content",
				},
				h.p() {
					"To get a custom domain, you need to create a website with Luau content.",
					"Consider hosting your website on GitHub Pages, Netlify, or Vercel.",
				},
				h.h2() {
					"Create a pull request to add your domain",
				},
				h.p() {
					"Once you have a website, create a pull request to add your subdomain to the ",
					h.a({ href = "https://github.com/Nicell/luau.page/blob/main/cname.luau" }) {
						"cname.luau",
					},
					" file.",
				},
				h.h2() {
					"Add the custom domain to your website",
				},
				h.p() {
					"Once your pull request is merged, you need to add the custom domain to your website.",
					"This is usually done in the settings of your hosting provider.",
					"It may take anywhere from a few minutes to a day for the DNS changes to propagate.",
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
}
