
function part1()
    inp = open(String ∘ read, "$(homedir())/aoc-input/2023/day8/input")

    path, maps = eachsplit(inp, "\n\n")

    maps_dict = Dict()

    reg = r"(\w+) = \((\w+), (\w+)\)"

    for l in eachsplit(maps, "\n")
        m = match(reg, l)
        if !isnothing(m)
            maps_dict[m.captures[1]] = (m.captures[2], m.captures[3])
        end
    end

    pos = "AAA"

    for (i, rl) in enumerate(Iterators.cycle(path))
        j = if rl == 'L'
            1
        else
            2
        end

        pos = maps_dict[pos][j]

        if pos == "ZZZ"
            return i
        end
    end
end

function part2()
    inp = open(String ∘ read, "$(homedir())/aoc-input/2023/day8/input")

    path, maps = eachsplit(inp, "\n\n")

    maps_dict = Dict()

    reg = r"(\w+) = \((\w+), (\w+)\)"

    for l in eachsplit(maps, "\n")
        m = match(reg, l)
        if !isnothing(m)
            maps_dict[m.captures[1]] = (m.captures[2], m.captures[3])
        end
    end

    positions = [p for p in keys(maps_dict) if endswith(p, "A")]

    period_starts = zeros(Int, length(positions))
    period_ends = zeros(Int, length(positions))

    for (i, rl) in enumerate(Iterators.cycle(path))
        j = if rl == 'L'
            1
        else
            2
        end

        for k in eachindex(positions)
            positions[k] = maps_dict[positions[k]][j]
            if endswith(positions[k], "Z")
                if period_starts[k] == 0
                    period_starts[k] = i
                elseif period_ends[k] == 0
                    period_ends[k] = i
                end
            end
        end

        if all(p != 0 for p in period_ends)
            periods = period_ends .- period_starts

            return lcm(periods)
        end
    end
end
