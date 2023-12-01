-- First, we'll read the input. From stdin, because we hate input.
-- Make sure it starts and ends with bounding characters, and compress all empty spaces into separating sequences
local input = ("<"..io.read("*all")..">"):gsub('%s+', '><');

-- Look this is just a regex problem okay
function trimGroups(input)
    return input
        :gsub("[^%d><]","") -- Remove everything which isn't a number or bounding character
        :gsub("<(%d)[^>]+(%d)>", "<%1%2>") -- Remove everything that's not at the start and end
        :gsub("<(%d)>", "<%1%1>") -- Duplicate single-characters
        :gsub("<>", "") -- Clean up after myself by removing empties
end

-- (Part 2; Still a regex problem)
local numbers = {"one","two","three","four","five","six","seven","eight","nine"}
function replaceNumbers(input)
    -- Because of some overlap, and no way to reliably disambiguate in Lua, we're going to a magic trick here,
    -- and it's going to hurt a lot.
    -- First, we're going to duplicate every single damned letter in this forsakened list
    input = input:gsub('%l', "%1%1");
    -- Then, we're going to go through our numbers
    for i,v in pairs(numbers) do
        nv = v
            :gsub('%l', "%1%1") -- But we're going to also duplicate every letter in the numbers
            :sub(2,-2) -- And then we're going to trim the ends
        input = input:gsub(nv, tostring(i))
    end
    return input

    -- Could we have done it without the padding hack? Sure. It could have been efficient, too.
    -- It just would have been confusing to read.
    -- We'd have to convert the list of <[i] = v> into a map of <[v] = tostring(i)>
    -- And then we'd use this ugly pattern: "[otfsen][nwhoie][eoruvxgn][erh]?[ent]?"
    -- And we'd gsub according to the table, or otherwise %1 (potentially using __index(t,k) = (_,k)->k)
    -- This is because Lua doesn't have all the features of Regex in its patterns
    -- And therefore can't do (one|two|three|...) into a DAG (without backtracking) the same way Regex can
    -- But I don't care, because this solution is still fast, because the input is small and Lua is fast
    -- And we're in 2023.
end

-- Part 1
local sum1 = 0
for value in trimGroups(input):gmatch("%d+") do
    sum1 = sum1 + tonumber(value)
end

-- Part 2
local sum2 = 0
for value in trimGroups(replaceNumbers(input)):gmatch("%d+") do
    sum2 = sum2 + tonumber(value)
end

print("Part 1", sum1)
print("Part 2", sum2)