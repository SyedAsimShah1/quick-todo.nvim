---@diagnostic disable: lowercase-global

local _MODREV, _SPECREV = "scm", "-1"
rockspec_format = "3.0"
version = _MODREV .. _SPECREV

local user = "SyedAsimShah1"
package = "quick-todo.nvim"

description = {
	summary = "A minimal Neovim plugin to quickly define and complete tasks per project.",
	labels = { "neovim" },
	homepage = "https://github.com/" .. user .. "/" .. package,
	license = "MIT",
}

test_dependencies = {
	"nlua",
}

source = {
	url = "git://github.com/" .. user .. "/" .. package,
}

build = {
	type = "builtin",
}
