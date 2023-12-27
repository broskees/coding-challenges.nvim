local Commands = require('includes/commands')
local request = require('http.request')
local htmlparser = require('htmlparser')
local AdventOfCode = {}

local function generate_url()
    math.randomseed(os.time())

    local year = math.random(2015, 2023)
    local day = math.random(1, 25)
    local url = 'https://adventofcode.com/' .. year .. '/day/' .. day

    if not Commands:is_new_challenge(url) then
        return generate_url()
    end

    return url
end

function AdventOfCode.get_challenge()
    local url = generate_url()
    local contents = request.new_from_url(url):go():get_body_as_string()
    local challenge = htmlparser.parse(contents):select('article.day-desc')[1]:getcontent()

    return challenge
end

return AdventOfCode
