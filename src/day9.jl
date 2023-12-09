
function diff_first!(nums)
    for i in 1:length(nums)-1
        nums[i] = nums[i+1] - nums[i]
    end

    @view nums[1:end-1]
end

function extrapolate(nums)
    dn = @inline diff_first!(nums)
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

function diff_last!(nums)
    for i in reverse(1:length(nums)-1)
        nums[i+1] = nums[i+1] - nums[i]
    end

    @view nums[2:end]
end

function extrapolate_back(nums)
    dn = diff_last!(nums)
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
