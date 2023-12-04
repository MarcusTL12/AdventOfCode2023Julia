
function part1()
    x = 0

    open("$(homedir())/aoc-input/2023/day4/input") do io
        for l in eachline(io)
            _, s = eachsplit(l, ": ")

            s1, s2 = eachsplit(s, " | ")

            s1 = split(s1)
            s2 = split(s2)

            st = intersect(Set(s1), Set(s2))

            if length(st) > 0
                y = 2^(length(st) - 1)
                x += y
            end
        end
    end

    x
end


function part2()
    winners = Int[]

    open("$(homedir())/aoc-input/2023/day4/input") do io
        for l in eachline(io)
            _, s = eachsplit(l, ": ")

            s1, s2 = eachsplit(s, " | ")

            s1 = split(s1)
            s2 = split(s2)

            st = intersect(Set(s1), Set(s2))

            push!(winners, length(st))
        end
    end

    n_cards = ones(Int, length(winners))

    for i in eachindex(winners)
        nw = winners[i]
        n_cards[(i+1):(i+nw)] .+= n_cards[i]
    end

    sum(n_cards)
end

