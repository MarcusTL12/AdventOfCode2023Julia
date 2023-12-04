
function part1()
    x = 0

    open("$(homedir())/aoc-input/2023/day4/input") do io
        for l in eachline(io)
            _, s = eachsplit(l, ": ")

            s1, s2 = eachsplit(s, " | ")

            s1 = split(s1)
            s2 = split(s2)

            st = intersect(Set(s1), Set(s2))

            @show st

            if length(st) > 0
                y = 2^(length(st) - 1)
                @show y
                x += y
            end
        end
    end

    x
end


function part2()
    x = 0

    scores = Int[]
    winners = Int[]

    open("$(homedir())/aoc-input/2023/day4/input") do io
        for l in eachline(io)
            _, s = eachsplit(l, ": ")

            s1, s2 = eachsplit(s, " | ")

            s1 = split(s1)
            s2 = split(s2)

            st = intersect(Set(s1), Set(s2))

            y = 0

            if length(st) > 0
                y = 2^(length(st) - 1)
            end

            push!(winners, length(st))
            push!(scores, y)
        end
    end

    n_cards = ones(Int, length(scores))

    for i in eachindex(scores)
        nw = winners[i]
        n_cards[(i+1):(i+nw)] .+= n_cards[i]
    end

    sum(n_cards)
end

