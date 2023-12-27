local Commands = {}
local Events = require('includes/events')
local AdventOfCode = require('challengers/advent_of_code')
local Lua = require('languages/lua')
local sqlite3 = require('lsqlite3')
local db_path = vim.fn.stdpath('data') .. '/coding_challenges.db'
local db = sqlite3.open(db_path)

-- Gets a random challenge
-- @return table
local function get_challenge()
    local challengers = Events:filter('challengers', {
        AdventOfCode
    })

    math.randomseed(os.time())
    local challenger = challengers[math.random(#challengers)]

    if not challenger.get_challenge then
        error('Challenger ' .. tostring(challenger) .. ' does not have a get_challenge function')
    end

    local challenge = challenger.get_challenge()

    if not challenge.contents then
        error('Challenge ' .. tostring(challenge) .. ' does not have a contents property')
    end

    if not challenge.url then
        error('Challenge ' .. tostring(challenge) .. ' does not have a url property')
    end

    return challenge
end

-- Gets a random language
-- @return table
local function get_challenge_language()
    local languages = Events:filter('languages', {
        Lua
    })

    math.randomseed(os.time())
    local language = languages[math.random(#languages)]

    if not language.name then
        error('Language ' .. tostring(language) .. ' does not have a name')
    end

    if not language.initialize then
        error('Language ' .. tostring(language) .. ' does not have an initialize function')
    end

    return language
end

-- Checks if a challenge is new
-- @param url The url of the challenge to check
-- @return boolean
function Commands:is_new_challenge(url)
    for row in db:nrows("SELECT 1 FROM challenge_history WHERE url = '" .. url .. "'") do
        return false
    end

    return true
end

-- Opens a two buffers: 
-- 1. with the challenge contents,
-- 2. with an empty file for implementation
-- @return void
function Commands:start_challenge()
    local challenge = get_challenge()
    local language = get_challenge_language()

    Events:fire('before_start_challenge', {
        challenge = challenge,
        language = language
    })

    print("Your daily challenge: " .. challenge.url)
    print("Your language: " .. language.name)

    -- Opens a new tab for the challenge contents
    vim.cmd('tabnew')
    local bufnr1 = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(bufnr1, 0, -1, false, {challenge.contents})

    -- Open a new tab for the implementation
    vim.cmd('tabnew')
    local bufnr2 = vim.api.nvim_get_current_buf()
    language.initialize(bufnr2)

    Events:fire('challenge_started', {
        challenge = challenge,
        language = language
    })
end

-- Checks if a challenge has been completed
-- @param url The url of the challenge to check
-- @return boolean
function Commands:is_challenge_completed(url)
    for row in db:nrows("SELECT 1 FROM challenge_history WHERE url = ".. url .." AND completed = true") do
        return true
    end

    return false
end

-- Marks a challenge as completed
-- Also closes the buffers associated with the challenge
-- @param url The url of the challenge to mark as completed
-- @return void
function Commands:mark_challenge_completed(url)
    Events:fire('before_mark_challenge_completed', {
        url = url
    })

    db:exec("INSERT INTO challenge_history (url, completed) VALUES (".. url ..", true)")

    Events:fire('challenge_completed', {
        url = url
    })
end

return Commands
