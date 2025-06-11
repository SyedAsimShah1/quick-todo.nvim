local M = {}

local state = {
  visible = false,
  window = -1,
  buffer = -1,
  location = "",
}

---Setup the quick-todo plugin
---@param opts Options: plugin options
M.setup = function(opts)
  require("quick-todo.config").setup(opts)
  require("quick-todo.commands").setup()

  vim.api.nvim_create_autocmd("DirChanged", {
    callback = function()
      if state.visible and vim.api.nvim_win_is_valid(state.window) then
        vim.api.nvim_win_close(state.window, false)
      end
      state.visible = false
      state.window = -1
      state.buffer = -1
      state.location = ""
    end,
  })
end

local function sanitize_path(path)
  return path:gsub("[/\\]", "__")
end

local function get_save_location()
  if state.location == "" then
    local cwd = vim.fn.getcwd()
    local data_dir = vim.fn.stdpath("data") .. "/quick-todo/"
    local file_dir = data_dir .. sanitize_path(cwd)
    local file_path = file_dir .. "/todo.md"

    vim.fn.mkdir(file_dir, "p")
    state.location = file_path
  end
  return state.location
end

local function update_window_and_buffer()
  if state.buffer == -1 or not vim.api.nvim_buf_is_valid(state.buffer) then
    local buffer = vim.api.nvim_create_buf(false, false)
    local todo_file = get_save_location()

    if vim.fn.filereadable(todo_file) == 1 then
      local lines = vim.fn.readfile(todo_file)
      vim.api.nvim_buf_set_lines(buffer, 0, -1, false, lines)
    else
      vim.api.nvim_buf_set_lines(buffer, 0, -1, false, { "# Project", "", "- [ ] Example todo" })
    end

    vim.api.nvim_buf_set_name(buffer, todo_file)
    vim.bo[buffer].filetype = "markdown"
    vim.bo[buffer].bufhidden = "hide"
    vim.bo[buffer].swapfile = false

    state.buffer = buffer
  end

  if state.window == -1 or not vim.api.nvim_win_is_valid(state.window) then
    local opts = require("quick-todo.config").options or {}
    local width = math.floor(vim.o.columns * opts.window.width)
    local height = math.floor(vim.o.lines * opts.window.height)
    local winblend = opts.window.winblend or 0
    local config = {
      relative = "editor",
      width = width,
      height = height,
      row = math.floor((vim.o.lines - height) / 2),
      col = math.floor((vim.o.columns - width) / 2),
      border = "rounded",
      title = "Quick Todo",
      title_pos = "center",
      footer = string.format("Project: %s", vim.fn.getcwd()),
      footer_pos = "left",
    }
    local win = vim.api.nvim_open_win(state.buffer, true, config)
    vim.wo[win].winblend = winblend
    state.window = win
  end
end

---Open todo window
M.open_todo = function()
  if state.visible then
    if vim.api.nvim_buf_is_valid(state.buffer) and vim.bo[state.buffer].modified then
      local lines = vim.api.nvim_buf_get_lines(state.buffer, 0, -1, false)
      vim.fn.writefile(lines, get_save_location())
      vim.bo[state.buffer].modified = false
    end

    if vim.api.nvim_win_is_valid(state.window) then
      local success = pcall(vim.api.nvim_win_hide, state.window)
      if not success then
        vim.api.nvim_win_close(state.window, false)
      end
    end
    state.visible = false
    state.window = -1

    return
  end

  update_window_and_buffer()
  state.visible = true
end

return M
