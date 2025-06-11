local commands = require("quick-todo.commands")
---@class Config
local M = {}

---@type Options
M.defaults = {
  keys = {
    open = "+",
  },
  window = {
    height = 0.5,
    width = 0.5,
    border = "rounded",
    winblend = 0,
  },
}

---@type Options
M.options = {}

---Extend the defaults options table with the user options
---@param opts Options: plugin options
M.setup = function(opts)
  M.options = vim.tbl_deep_extend("force", {}, M.defaults, opts or {})

  for subcmd, def in pairs(commands.sub_cmds) do
    local key = M.options.keys[subcmd]
    if key then
      vim.keymap.set("n", key, function()
        vim.cmd("QuickTodo " .. subcmd)
      end, { desc = "QuickTodo: " .. def.desc })
    end
  end
end

return M
