---@meta
--- This is a simple "definition file" (https://luals.github.io/wiki/definition-files/),
--- the @meta tag at the top is its hallmark.

-- lua/quick-todo/init.lua -----------------------------------------------------------

---@class QuickTodo
---@field setup function: setup the plugin
---@field open_todo function: Open the todo window

-- lua/quick-todo/config.lua ---------------------------------------------------------

---@class Config
---@field defaults Options: default options
---@field options Options: user options
---@field setup function: setup the plugin

---@class Keys
---@field open string: key for opening todo window

---@class WindowOptions
---@field height? integer: window height
---@field width? integer: window width
---@field border? string: window border
---@field winblend? integer: window transparency

---@class Options
---@field keys? Keys: Keymap
---@field window? WindowOptions: Options for todo window
