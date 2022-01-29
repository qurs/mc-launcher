file = file or {}

function file.Read(dir)
    local File = io.open(dir, 'r')
    if not File then return false end

    local read = File:read('a')
    File:close()

    return read
end

function file.Write(dir, val)
    local File = io.open(dir, 'w')
    if not File then return false end

    File:write(val)
    File:flush()
    File:close()

    return true
end