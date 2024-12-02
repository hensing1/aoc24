#! /usr/bin/lua

local function check_increase(a, b)
	local diff = b - a
	return 0 < diff and diff < 4
end

local function do_local_check(list)
	if list[1] == nil then
		return check_increase(list[2], list[3])
	end
	if list[3] == nil then
		return check_increase(list[1], list[2])
	end

	return check_increase(list[1], list[2]) and check_increase(list[2], list[3])
end

local function is_safe_upwards(list)
	local index = 1
	local has_skipped_level = false

	while list[index + 1] ~= nil do
		if not check_increase(list[index], list[index + 1]) then
			if has_skipped_level then
				return false
			end
			if do_local_check({
				list[index - 1],
				list[index],
				list[index + 2],
			}) then
				index = index + 1
				has_skipped_level = true
			elseif do_local_check({
				list[index - 1],
				list[index + 1],
				list[index + 2],
			}) then
				has_skipped_level = true
			else
				return false
			end
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

local function reverse(list)
	local reversed = {}
	for i = #list, 1, -1 do
		reversed[#reversed + 1] = list[i]
	end
	return reversed
end

local function is_safe(list)
	return is_safe_upwards(list) or is_safe_upwards(reverse(list))
end

local safe_count = 0
while true do
	local line = io.read()
	if line == nil then
		break
	end
	local current = parse_line(line)
	if is_safe(current) then
		safe_count = safe_count + 1
	end
end
print(safe_count)
