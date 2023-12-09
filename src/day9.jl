
function part1()
    x = 0

    open("$(homedir())/aoc-input/2023/day9/input") do io
        for l in eachline(io)
            nums = [parse.(Int, eachsplit(l))]

            while !all(==(0), nums[end])
                push!(nums, diff(nums[end]))
            end

            lastnums = [0]

            for i in reverse(1:length(nums) - 1)
                push!(lastnums, nums[i][end] + lastnums[end])
            end

            x += lastnums[end]
        end
    end

    x
end

function part2()
    x = 0

    open("$(homedir())/aoc-input/2023/day9/input") do io
        for l in eachline(io)
            nums = [parse.(Int, eachsplit(l))]

            while !all(==(0), nums[end])
                push!(nums, diff(nums[end]))
            end

            firstnums = [0]

            for i in reverse(1:length(nums) - 1)
                push!(firstnums, nums[i][1] - firstnums[end])
            end

            x += firstnums[end]
        end
    end

    x
end
