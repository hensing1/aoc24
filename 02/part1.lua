#! /usr/bin/lua

local function is_safe_upwards(list)
	local index = 1
	while list[index + 1] ~= nil do
		local diff = list[index + 1] - list[index]
		if diff < 1 or 3 < diff then
			return false
		end
		index = index + 1
	end
	return true
end

local function is_safe_downwards(list)
	local index = 1
	while list[index + 1] ~= nil do
		local diff = list[index] - list[index + 1]
		if diff < 1 or 3 < diff then
			return false
		end
		index = index + 1
	end
	return true
end

local function parse_line(line)
	local t = {}
	for str in string.gmatch(line, "([^%s]+)") do
		table.insert(t, tonumber(str))
	end
	return t
end

local safe_count = 0
while true do
	local line = io.read()
	if line == nil then
		break
	end
	local current = parse_line(line)
	if is_safe_upwards(current) or is_safe_downwards(current) then
		safe_count = safe_count + 1
	end
end
print(safe_count)
