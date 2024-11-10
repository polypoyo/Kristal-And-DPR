-- Various metatable tweaks

local string_metatable = getmetatable(" ")

-- "string" + "string2"
string_metatable.__add = function (a, b) return a .. tostring(b) end

-- "string" * number
string_metatable.__mul = function (a, b)
    local result = ""
    for i = 1, b do
        result = result .. a
    end
    return result
end

-- ("string")[1]
string_metatable.__index = function (a, b)
    if type(b) == "number" then
        return string.sub(a, b, b)
    else
        return string[b]
    end
end

-- "string is " .. true
-- "string" .. {1, 2, 3}
-- "string" .. Sprite()
string_metatable.__concat = function (a, b)
    -- Do not allow nil to be concatenated
    if type(b) == "nil" then
        return a..""
    end

    -- If it's a class, concatenate its name
    if isClass(b) then
        return a..Utils.getClassName(b)
    -- If it's a table, dump it
    elseif type(b) == "table" then
        return a..Utils.dump(b)
    end
    -- Just convert it to a string
    return a..tostring(b)
end