local M = {}

M.sub_cmds = {
  open = {
    cmd = function()
      require("quick-todo").open_todo()
    end,
    desc = "Open the todo window",
  },
}

function M.setup()
  local sub_cmds_keys = vim.tbl_keys(M.sub_cmds)

  vim.api.nvim_create_user_command("QuickTodo", function(opts)
    local sub = M.sub_cmds[opts.args]
    if sub then
      sub.cmd()
    else
      vim.notify("Invalid subcommand: " .. opts.args, vim.log.levels.ERROR)
    end
  end, {
    nargs = "?",
    desc = "QuickTodo commands",
    complete = function(arg_lead)
      return vim
        .iter(sub_cmds_keys)
        :filter(function(cmd)
          return cmd:find(arg_lead, 1, true)
        end)
        :totable()
    end,
  })
end

return M
