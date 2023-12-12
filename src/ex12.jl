
function is_good(line, nums)
    s = split(String(line), '.')
    filter!(!isempty, s)
    length.(s) == nums
end

function part1()
    num_ways = 0

    open("$(homedir())/aoc-input/2023/day12/input") do io
        for l in eachline(io)
            line, nums = eachsplit(l)
            unknown_indices = Int[]
            line = Vector{Char}(line)
            nums = parse.(Int, eachsplit(nums, ','))

            for (i, c) in enumerate(line)
                if c == '?'
                    push!(unknown_indices, i)
                end
            end

            for i in 0:2^(length(unknown_indices))-1
                for j in eachindex(unknown_indices)
                    x = (i & (1 << (j - 1))) == 0 ? '.' : '#'
                    line[unknown_indices[j]] = x
                end

                if is_good(line, nums)
                    num_ways += 1
                end
            end
        end
    end

    num_ways
end

function find_num_ways_smart(memo, line, nums, i, groupsize, i_group)
    k = (i, groupsize, i_group)

    if i > length(line)
        if i_group == length(nums) && groupsize == nums[i_group] ||
           i_group == length(nums) + 1 && groupsize == 0
            return 1
        else
            return 0
        end
    end

    if haskey(memo, k)
        return memo[k]
    end

    a = if line[i] == '#' || line[i] == '?'
        if groupsize < get(nums, i_group, 0)
            find_num_ways_smart(memo, line, nums, i + 1, groupsize + 1, i_group)
        else
            0
        end
    else
        0
    end

    b = if line[i] == '.' || line[i] == '?'
        if groupsize == 0
            find_num_ways_smart(memo, line, nums, i + 1, 0, i_group)
        elseif groupsize == nums[i_group]
            find_num_ways_smart(memo, line, nums, i + 1, 0, i_group + 1)
        else
            0
        end
    else
        0
    end

    memo[k] = a + b
end

function part2()
    num_ways = 0

    open("$(homedir())/aoc-input/2023/day12/input") do io
        for l in eachline(io)
            line, nums = eachsplit(l)
            line = Vector{Char}(join(repeat([line], 5), '?'))
            nums = repeat(parse.(Int, eachsplit(nums, ',')), 5)

            num_ways += find_num_ways_smart(
                Dict{NTuple{3,Int},Int}(), line, nums, 1, 0, 1
            )
        end
    end

    num_ways
end
