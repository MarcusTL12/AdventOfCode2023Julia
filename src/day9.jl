
function extrapolate(nums)
    dn = diff(nums)
    if all(==(0), dn)
        last(nums)
    else
        last(nums) + extrapolate(dn)
    end
end

function part1()
    open("$(homedir())/aoc-input/2023/day9/input") do io
        sum(extrapolate(parse.(Int, eachsplit(l))) for l in eachline(io))
    end
end

function extrapolate_back(nums)
    dn = diff(nums)
    if all(==(0), dn)
        first(nums)
    else
        first(nums) - extrapolate_back(dn)
    end
end

function part2()
    open("$(homedir())/aoc-input/2023/day9/input") do io
        sum(extrapolate_back(parse.(Int, eachsplit(l))) for l in eachline(io))
    end
end
