package = "coding-challenges.nvim"
version = "beta"
source = {
    url = "git://github.com/broskees/coding-challenges.nvim",
    branch = "master"
}
description = {
    summary = "A Neovim plugin for coding challenges.",
    detailed = [[
        This plugin integrates with Neovim to provide a new coding challenge on command.
    ]],
    homepage = "http://github.com/broskees/coding-challenges.nvim",
    license = "MIT"
}
dependencies = {
    "lua >= 5.1, < 5.4",
    "lsqlite3complete",
    "htmlparser"
}
build = {
    type = "builtin",
    modules = {
        ["coding_challenges"] = "src/coding_challenges.lua"
    }
}
