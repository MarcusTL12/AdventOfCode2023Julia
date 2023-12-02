
function part1()
    x = 0

    reg = r"(\d+) (\w+)"

    open("$(homedir())/aoc-input/2023/day2/input") do io
        for (id, l) in enumerate(eachline(io))
            lc = split(l, ": ")[2]
            color_dict = Dict()
            for part in eachsplit(lc, "; ")
                for m in eachmatch(reg, part)
                    n = parse(Int, m.captures[1])
                    color = m.captures[2]
                    color_dict[color] = max(get(color_dict, color, 0), n)
                end
            end

            if get(color_dict, "red", 0) <= 12 &&
               get(color_dict, "green", 0) <= 13 &&
               get(color_dict, "blue", 0) <= 14
                x += id
            end
        end
    end

    x
end

function part2()
    x = 0

    reg = r"(\d+) (\w+)"

    open("$(homedir())/aoc-input/2023/day2/input") do io
        for (id, l) in enumerate(eachline(io))
            lc = split(l, ": ")[2]
            color_dict = Dict()
            for part in eachsplit(lc, "; ")
                for m in eachmatch(reg, part)
                    n = parse(Int, m.captures[1])
                    color = m.captures[2]
                    color_dict[color] = max(get(color_dict, color, 0), n)
                end
            end

            pow = get(color_dict, "red", 0) * get(color_dict, "green", 0) *
                  get(color_dict, "blue", 0)

            x += pow

        end
    end

    x
end
