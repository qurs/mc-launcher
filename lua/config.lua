local json = require('json')
local lfs = require('lfs')

CFG = CFG or {}

function CFG.check()

    lfs.mkdir('config')

    if not file.Read('config/user.json') then
        CFG.create()
    else
        CFG.load()
    end

end

function CFG.create()
    CFG.user = CFG.user or {}

    io.write('Type your nickname: ')

    local txt = io.read()
    txt = string.Trim(txt)

    CFG.user.name = txt

    file.Write('config/user.json', json.encode(CFG.user))
end

function CFG.load()
    local rawData = file.Read('config/user.json')
    local data = json.decode(rawData)

    CFG.user = data
end