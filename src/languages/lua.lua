local Lua = {}

Lua.name = 'Lua'

-- Creates a new lua project in the current directory
Lua.initialize = function(bufferNum)
  print('Initializing Lua')
  vim.api.nvim_buf_set_option(bufferNum, 'filetype', 'lua')

  local boilerplate = {
    '-- Lua Challenge',
    '-- Write your code here',
    '',
  }

  vim.api.nvim_buf_set_lines(bufferNum, 0, -1, false, boilerplate)
end

return Lua
