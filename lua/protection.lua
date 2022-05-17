local http = require('socket.http')
local json = require('json')
local lfs = require('lfs')

local protect = {}

function protect.checkMods()
    local mods = {}
    local cur_dir = lfs.currentdir()
    
    for mod in lfs.dir(cur_dir .. '\\game\\mods') do
        if string.find(mod, '.jar') then
            mods[#mods + 1] = mod
        end
    end

    local b = http.request('http://qmc.tria.su/api.php', json.encode{
        mods = json.encode(mods),
        nick = CFG.user.name,
    })
end

function protect.checkResourcepacks()
    local resourcepacks = {}
    local cur_dir = lfs.currentdir()
    
    for mod in lfs.dir(cur_dir .. '\\game\\resourcepacks') do
        if mod ~= '.' and mod ~= '..' then
            local str = string.fromutf8(mod)
            str = string.gsub(string.fromutf8(mod), ' ', '')

            resourcepacks[#resourcepacks + 1] = str
        end
    end

    local b = http.request('http://qmc.tria.su/api.php', json.encode{
        resourcepacks = json.encode(resourcepacks),
        nick = CFG.user.name,
    })
end

return protect