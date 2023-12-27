local sqlite3 = require('lsqlite3')
local db_path = vim.fn.stdpath('data') .. '/coding_challenges.db'
local db = sqlite3.open(db_path)
local Commands = require('includes/commands')

-- Initialize the database
db:exec[[
  CREATE TABLE IF NOT EXISTS challenge_history (
    year INTEGER NOT NULL,
    day INTEGER NOT NULL,
    PRIMARY KEY (year, day)
  )
]]

-- Neovim integration part
vim.api.nvim_create_user_command('Challenge', Commands.start_challenge, {})
vim.api.nvim_create_user_command('ChallengeCompleted', Commands.mark_challenge_completed, {nargs = '?'})
