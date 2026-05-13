local h = require("./htmluau/src")

local FAVICON =
	"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAGFBMVEUAov4Aov4Aof4Aov7l8/6l0v5ctP4Fof7s4QukAAAABHRSTlMBRY/MU7dEywAAALZJREFUeNqNk0EOwyAMBGvs3f3/j1sXWkKDK+biQ0YwisXjFPdm/76bJL0cq4VBdVBTp5RcSS2ZbqxJTQVe3QBwEfRLJJRakcCPYEUCIqkTugCpVQkEqoQJJdn5XwB1Y7khtoJ9BYR2zEUAkkBxmzBuYOQkuEnIbwJyAgFxSWgpAATSec8QMRM8ZYIIBIGUIewW0c9g9JkJA7N2lSKTx6on00nrsupC4txkLdWPzNxrYR7kp8/+CUlvDvtDdoJIAAAAAElFTkSuQmCC"
local PICO_CSS = "https://cdn.jsdelivr.net/npm/@picocss/pico@2.1.1/css/pico.classless.min.css"

export type LayoutProps = {
	title: string,
	description: string,
	body: { any },
}

return function(props: LayoutProps)
	local bodyChildren = {
		h.nav() {
			h.ul() {
				h.li() {
					h.strong() {
						h.a({ href = "/" }) {
							"Luau.Page",
						},
					},
				},
			},
			h.ul() {
				h.li() {
					h.a({ href = "/packages" }) {
						"Loom Packages",
					},
				},
			},
		},
	}

	for _, child in props.body do
		table.insert(bodyChildren, child)
	end

	return h.html({ lang = "en" }) {
		h.head() {
			h.meta({ charset = "utf-8" }),
			h.meta({ name = "viewport", content = "width=device-width, initial-scale=1" }),
			h.meta({ name = "color-scheme", content = "dark light" }),
			h.title() {
				props.title,
			},
			h.meta({ name = "description", content = props.description }),
			h.link({ rel = "icon", href = FAVICON }),
			h.link({ rel = "stylesheet", href = PICO_CSS }),
		},
		h.body()(bodyChildren),
	}
end
