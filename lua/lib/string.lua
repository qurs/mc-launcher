local math = math

--[[---------------------------------------------------------
	Name: string.ToTable( string )
-----------------------------------------------------------]]
function string.ToTable( str )
	local tbl = {}

	for i = 1, string.len( str ) do
		tbl[i] = string.sub( str, i, i )
	end

	return tbl
end

--[[---------------------------------------------------------
	Name: string.JavascriptSafe( string )
	Desc: Takes a string and escapes it for insertion in to a JavaScript string
-----------------------------------------------------------]]
local javascript_escape_replacements = {
	["\\"] = "\\\\",
	["\0"] = "\\x00" ,
	["\b"] = "\\b" ,
	["\t"] = "\\t" ,
	["\n"] = "\\n" ,
	["\v"] = "\\v" ,
	["\f"] = "\\f" ,
	["\r"] = "\\r" ,
	["\""] = "\\\"",
	["\'"] = "\\\'",
	["`"] = "\\`"
}

function string.JavascriptSafe( str )

	str = str:gsub( ".", javascript_escape_replacements )

	-- U+2028 and U+2029 are treated as line separators in JavaScript, handle separately as they aren't single-byte
	str = str:gsub( "\226\128\168", "\\\226\128\168" )
	str = str:gsub( "\226\128\169", "\\\226\128\169" )

	return str

end

--[[---------------------------------------------------------
	Name: string.PatternSafe( string )
	Desc: Takes a string and escapes it for insertion in to a Lua pattern
-----------------------------------------------------------]]
local pattern_escape_replacements = {
	["("] = "%(",
	[")"] = "%)",
	["."] = "%.",
	["%"] = "%%",
	["+"] = "%+",
	["-"] = "%-",
	["*"] = "%*",
	["?"] = "%?",
	["["] = "%[",
	["]"] = "%]",
	["^"] = "%^",
	["$"] = "%$",
	["\0"] = "%z"
}

function string.PatternSafe( str )
	return ( str:gsub( ".", pattern_escape_replacements ) )
end

--[[---------------------------------------------------------
	Name: explode(seperator ,string)
	Desc: Takes a string and turns it into a table
	Usage: string.explode( " ", "Seperate this string")
-----------------------------------------------------------]]
local totable = string.ToTable
local string_sub = string.sub
local string_find = string.find
local string_len = string.len
function string.Explode(separator, str, withpattern)
	if ( separator == "" ) then return totable( str ) end
	if ( withpattern == nil ) then withpattern = false end

	local ret = {}
	local current_pos = 1

	for i = 1, string_len( str ) do
		local start_pos, end_pos = string_find( str, separator, current_pos, not withpattern )
		if ( not start_pos ) then break end
		ret[ i ] = string_sub( str, current_pos, start_pos - 1 )
		current_pos = end_pos + 1
	end

	ret[ #ret + 1 ] = string_sub( str, current_pos )

	return ret
end

function string.Split( str, delimiter )
	return string.Explode( delimiter, str )
end

--[[---------------------------------------------------------
	Name: Implode( seperator, Table)
	Desc: Takes a table and turns it into a string
	Usage: string.Implode( " ", { "This", "Is", "A", "Table" } )
-----------------------------------------------------------]]
function string.Implode( seperator, Table ) return
	table.concat( Table, seperator )
end

--[[---------------------------------------------------------
	Name: GetExtensionFromFilename( path )
	Desc: Returns extension from path
	Usage: string.GetExtensionFromFilename("garrysmod/lua/modules/string.lua")
-----------------------------------------------------------]]
function string.GetExtensionFromFilename( path )
	return path:match( "%.([^%.]+)$" )
end

--[[---------------------------------------------------------
	Name: StripExtension( path )
-----------------------------------------------------------]]
function string.StripExtension( path )
	local i = path:match( ".+()%.%w+$" )
	if ( i ) then return path:sub( 1, i - 1 ) end
	return path
end

--[[---------------------------------------------------------
	Name: GetPathFromFilename( path )
	Desc: Returns path from filepath
	Usage: string.GetPathFromFilename("garrysmod/lua/modules/string.lua")
-----------------------------------------------------------]]
function string.GetPathFromFilename( path )
	return path:match( "^(.*[/\\])[^/\\]-$" ) or ""
end

--[[---------------------------------------------------------
	Name: GetFileFromFilename( path )
	Desc: Returns file with extension from path
	Usage: string.GetFileFromFilename("garrysmod/lua/modules/string.lua")
-----------------------------------------------------------]]
function string.GetFileFromFilename( path )
	if ( not path:find( "\\" ) and not path:find( "/" ) ) then return path end 
	return path:match( "[\\/]([^/\\]+)$" ) or ""
end

--[[-----------------------------------------------------------------
	Name: FormattedTime( TimeInSeconds, Format )
	Desc: Given a time in seconds, returns formatted time
			If 'Format' is not specified the function returns a table
			conatining values for hours, mins, secs, ms
	Examples: string.FormattedTime( 123.456, "%02i:%02i:%02i")	==> "02:03:45"
			  string.FormattedTime( 123.456, "%02i:%02i")		==> "02:03"
			  string.FormattedTime( 123.456, "%2i:%02i")		==> " 2:03"
			  string.FormattedTime( 123.456 )					==> { h = 0, m = 2, s = 3, ms = 45 }
-------------------------------------------------------------------]]
function string.FormattedTime( seconds, format )
	if ( not seconds ) then seconds = 0 end
	local hours = math.floor( seconds / 3600 )
	local minutes = math.floor( ( seconds / 60 ) % 60 )
	local millisecs = ( seconds - math.floor( seconds ) ) * 100
	seconds = math.floor( seconds % 60 )

	if ( format ) then
		return string.format( format, minutes, seconds, millisecs )
	else
		return { h = hours, m = minutes, s = seconds, ms = millisecs }
	end
end

--[[---------------------------------------------------------
	Name: Old time functions
-----------------------------------------------------------]]
function string.ToMinutesSecondsMilliseconds( TimeInSeconds ) return string.FormattedTime( TimeInSeconds, "%02i:%02i:%02i" ) end
function string.ToMinutesSeconds( TimeInSeconds ) return string.FormattedTime( TimeInSeconds, "%02i:%02i" ) end

local function pluralizeString( str, quantity )
	return str .. ( ( quantity ~= 1 ) and "s" or "" )
end

function string.NiceTime( seconds )

	if ( seconds == nil ) then return "a few seconds" end

	if ( seconds < 60 ) then
		local t = math.floor( seconds )
		return t .. pluralizeString( " second", t )
	end

	if ( seconds < 60 * 60 ) then
		local t = math.floor( seconds / 60 )
		return t .. pluralizeString( " minute", t )
	end

	if ( seconds < 60 * 60 * 24 ) then
		local t = math.floor( seconds / (60 * 60) )
		return t .. pluralizeString( " hour", t )
	end

	if ( seconds < 60 * 60 * 24 * 7 ) then
		local t = math.floor( seconds / ( 60 * 60 * 24 ) )
		return t .. pluralizeString( " day", t )
	end

	if ( seconds < 60 * 60 * 24 * 365 ) then
		local t = math.floor( seconds / ( 60 * 60 * 24 * 7 ) )
		return t .. pluralizeString( " week", t )
	end

	local t = math.floor( seconds / ( 60 * 60 * 24 * 365 ) )
	return t .. pluralizeString( " year", t )

end

function string.Left( str, num ) return string.sub( str, 1, num ) end
function string.Right( str, num ) return string.sub( str, -num ) end

function string.Replace( str, tofind, toreplace )
	local tbl = string.Explode( tofind, str )
	if ( tbl[ 1 ] ) then return table.concat( tbl, toreplace ) end
	return str
end

--[[---------------------------------------------------------
	Name: Trim( s )
	Desc: Removes leading and trailing spaces from a string.
			Optionally pass char to trim that character from the ends instead of space
-----------------------------------------------------------]]
function string.Trim( s, char )
	if ( char ) then char = char:PatternSafe() else char = "%s" end
	return string.match( s, "^" .. char .. "*(.-)" .. char .. "*$" ) or s
end

--[[---------------------------------------------------------
	Name: TrimRight( s )
	Desc: Removes trailing spaces from a string.
			Optionally pass char to trim that character from the ends instead of space
-----------------------------------------------------------]]
function string.TrimRight( s, char )
	if ( char ) then char = char:PatternSafe() else char = "%s" end
	return string.match( s, "^(.-)" .. char .. "*$" ) or s
end

--[[---------------------------------------------------------
	Name: TrimLeft( s )
	Desc: Removes leading spaces from a string.
			Optionally pass char to trim that character from the ends instead of space
-----------------------------------------------------------]]
function string.TrimLeft( s, char )
	if ( char ) then char = char:PatternSafe() else char = "%s" end
	return string.match( s, "^" .. char .. "*(.+)$" ) or s
end

function string.NiceSize( size )

	size = tonumber( size )

	if ( size <= 0 ) then return "0" end
	if ( size < 1000 ) then return size .. " Bytes" end
	if ( size < 1000 * 1000 ) then return math.Round( size / 1000, 2 ) .. " KB" end
	if ( size < 1000 * 1000 * 1000 ) then return math.Round( size / ( 1000 * 1000 ), 2 ) .. " MB" end

	return math.Round( size / ( 1000 * 1000 * 1000 ), 2 ) .. " GB"

end

-- Note: These use Lua index numbering, not what you'd expect
-- ie they start from 1, not 0.

function string.SetChar( s, k, v )

	local start = s:sub( 0, k - 1 )
	local send = s:sub( k + 1 )

	return start .. v .. send

end

function string.GetChar( s, k )

	return s:sub( k, k )

end

local meta = getmetatable( "" )

function meta:__index( key )

	local val = string[ key ]
	if ( val ~= nil ) then
		return val
	elseif ( tonumber( key ) ) then
		return self:sub( key, key )
	end

end

function string.StartWith( String, Start )

	return string.sub( String, 1, string.len( Start ) ) == Start

end

function string.EndsWith( String, End )

	return End == "" or string.sub( String, -string.len( End ) ) == End

end

function string.FromColor( color )

	return Format( "%i %i %i %i", color.r, color.g, color.b, color.a )

end

function string.ToColor( str )

	local col = Color( 255, 255, 255, 255 )

	local r, g, b, a = str:match( "(%d+) (%d+) (%d+) (%d+)" )

	col.r = tonumber( r ) or 255
	col.g = tonumber( g ) or 255
	col.b = tonumber( b ) or 255
	col.a = tonumber( a ) or 255

	return col

end

function string.Comma( number )

	if ( isnumber( number ) ) then number = tostring( number ) end

	local index = -1
	while index ~= 0 do number, index = number:gsub( "^(-?%d+)(%d%d%d)", "%1,%2" ) end

	return number

end

local char, byte, pairs, floor = string.char, string.byte, pairs, math.floor
local table_insert, table_concat = table.insert, table.concat
local unpack = table.unpack or unpack

local function unicode_to_utf8(code)
   -- converts numeric UTF code (U+code) to UTF-8 string
   local t, h = {}, 128
   while code >= h do
      t[#t+1] = 128 + code%64
      code = floor(code/64)
      h = h > 32 and 32 or h/2
   end
   t[#t+1] = 256 - 2*h + code
   return char(unpack(t)):reverse()
end

local function utf8_to_unicode(utf8str, pos)
   -- pos = starting byte position inside input string (default 1)
   pos = pos or 1
   local code, size = utf8str:byte(pos), 1
   if code >= 0xC0 and code < 0xFE then
      local mask = 64
      code = code - 128
      repeat
         local next_byte = utf8str:byte(pos + size) or 0
         if next_byte >= 0x80 and next_byte < 0xC0 then
            code, size = (code - mask - 2) * 64 + next_byte, size + 1
         else
            code, size = utf8str:byte(pos), 1
         end
         mask = mask * 32
      until code < mask
   end
   -- returns code, number of bytes in this utf8 char
   return code, size
end

local map_1252_to_unicode = {
   [0x80] = 0x20AC,
   [0x81] = 0x81,
   [0x82] = 0x201A,
   [0x83] = 0x0192,
   [0x84] = 0x201E,
   [0x85] = 0x2026,
   [0x86] = 0x2020,
   [0x87] = 0x2021,
   [0x88] = 0x02C6,
   [0x89] = 0x2030,
   [0x8A] = 0x0160,
   [0x8B] = 0x2039,
   [0x8C] = 0x0152,
   [0x8D] = 0x8D,
   [0x8E] = 0x017D,
   [0x8F] = 0x8F,
   [0x90] = 0x90,
   [0x91] = 0x2018,
   [0x92] = 0x2019,
   [0x93] = 0x201C,
   [0x94] = 0x201D,
   [0x95] = 0x2022,
   [0x96] = 0x2013,
   [0x97] = 0x2014,
   [0x98] = 0x02DC,
   [0x99] = 0x2122,
   [0x9A] = 0x0161,
   [0x9B] = 0x203A,
   [0x9C] = 0x0153,
   [0x9D] = 0x9D,
   [0x9E] = 0x017E,
   [0x9F] = 0x0178,
   [0xA0] = 0x00A0,
   [0xA1] = 0x00A1,
   [0xA2] = 0x00A2,
   [0xA3] = 0x00A3,
   [0xA4] = 0x00A4,
   [0xA5] = 0x00A5,
   [0xA6] = 0x00A6,
   [0xA7] = 0x00A7,
   [0xA8] = 0x00A8,
   [0xA9] = 0x00A9,
   [0xAA] = 0x00AA,
   [0xAB] = 0x00AB,
   [0xAC] = 0x00AC,
   [0xAD] = 0x00AD,
   [0xAE] = 0x00AE,
   [0xAF] = 0x00AF,
   [0xB0] = 0x00B0,
   [0xB1] = 0x00B1,
   [0xB2] = 0x00B2,
   [0xB3] = 0x00B3,
   [0xB4] = 0x00B4,
   [0xB5] = 0x00B5,
   [0xB6] = 0x00B6,
   [0xB7] = 0x00B7,
   [0xB8] = 0x00B8,
   [0xB9] = 0x00B9,
   [0xBA] = 0x00BA,
   [0xBB] = 0x00BB,
   [0xBC] = 0x00BC,
   [0xBD] = 0x00BD,
   [0xBE] = 0x00BE,
   [0xBF] = 0x00BF,
   [0xC0] = 0x00C0,
   [0xC1] = 0x00C1,
   [0xC2] = 0x00C2,
   [0xC3] = 0x00C3,
   [0xC4] = 0x00C4,
   [0xC5] = 0x00C5,
   [0xC6] = 0x00C6,
   [0xC7] = 0x00C7,
   [0xC8] = 0x00C8,
   [0xC9] = 0x00C9,
   [0xCA] = 0x00CA,
   [0xCB] = 0x00CB,
   [0xCC] = 0x00CC,
   [0xCD] = 0x00CD,
   [0xCE] = 0x00CE,
   [0xCF] = 0x00CF,
   [0xD0] = 0x00D0,
   [0xD1] = 0x00D1,
   [0xD2] = 0x00D2,
   [0xD3] = 0x00D3,
   [0xD4] = 0x00D4,
   [0xD5] = 0x00D5,
   [0xD6] = 0x00D6,
   [0xD7] = 0x00D7,
   [0xD8] = 0x00D8,
   [0xD9] = 0x00D9,
   [0xDA] = 0x00DA,
   [0xDB] = 0x00DB,
   [0xDC] = 0x00DC,
   [0xDD] = 0x00DD,
   [0xDE] = 0x00DE,
   [0xDF] = 0x00DF,
   [0xE0] = 0x00E0,
   [0xE1] = 0x00E1,
   [0xE2] = 0x00E2,
   [0xE3] = 0x00E3,
   [0xE4] = 0x00E4,
   [0xE5] = 0x00E5,
   [0xE6] = 0x00E6,
   [0xE7] = 0x00E7,
   [0xE8] = 0x00E8,
   [0xE9] = 0x00E9,
   [0xEA] = 0x00EA,
   [0xEB] = 0x00EB,
   [0xEC] = 0x00EC,
   [0xED] = 0x00ED,
   [0xEE] = 0x00EE,
   [0xEF] = 0x00EF,
   [0xF0] = 0x00F0,
   [0xF1] = 0x00F1,
   [0xF2] = 0x00F2,
   [0xF3] = 0x00F3,
   [0xF4] = 0x00F4,
   [0xF5] = 0x00F5,
   [0xF6] = 0x00F6,
   [0xF7] = 0x00F7,
   [0xF8] = 0x00F8,
   [0xF9] = 0x00F9,
   [0xFA] = 0x00FA,
   [0xFB] = 0x00FB,
   [0xFC] = 0x00FC,
   [0xFD] = 0x00FD,
   [0xFE] = 0x00FE,
   [0xFF] = 0x00FF,
}
local map_unicode_to_1252 = {}
for code1252, code in pairs(map_1252_to_unicode) do
   map_unicode_to_1252[code] = code1252
end

function string.fromutf8(utf8str)
   local pos, result_1252 = 1, {}
   while pos <= #utf8str do
      local code, size = utf8_to_unicode(utf8str, pos)
      pos = pos + size
      code = code < 128 and code or map_unicode_to_1252[code] or ('?'):byte()
      table_insert(result_1252, char(code))
   end
   return table_concat(result_1252)
end

function string.toutf8(str1252)
   local result_utf8 = {}
   for pos = 1, #str1252 do
      local code = str1252:byte(pos)
      table_insert(result_utf8, unicode_to_utf8(map_1252_to_unicode[code] or code))
   end
   return table_concat(result_utf8)
end