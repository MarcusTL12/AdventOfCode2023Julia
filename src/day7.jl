using StaticArrays

function tocardnum(c)
    if isdigit(c)
        c - '0'
    elseif c == 'T'
        10
    elseif c == 'J'
        11
    elseif c == 'Q'
        12
    elseif c == 'K'
        13
    elseif c == 'A'
        14
    else
        throw("Illegal card!")
    end
end

function find_hand_counts(hand)
    counts = @MVector [0 for _ in 2:14]

    for c in hand
        counts[c-1] += 1
    end

    counts
end

function find_hand_type(hand)
    counts = find_hand_counts(hand)

    if any(c == 5 for c in counts)
        7
    elseif any(c == 4 for c in counts)
        6
    elseif any(c == 3 for c in counts) && any(c == 2 for c in counts)
        5
    elseif any(c == 3 for c in counts)
        4
    elseif any(c == 2 for c in counts)
        p1 = findfirst(==(2), counts)
        if any(c == 2 for (i, c) in enumerate(counts) if i != p1)
            3
        else
            2
        end
    else
        1
    end
end

function part1()
    hands = Tuple{Int,SVector{5,Int},Int}[]

    open("$(homedir())/aoc-input/2023/day7/input") do io
        for l in eachline(io)
            h, b = eachsplit(l)
            hand = SVector((tocardnum(c) for c in h)...)
            b = parse(Int, b)

            push!(hands, (find_hand_type(hand), hand, b))
        end
    end

    sort!(hands)

    sum(b * i for (i, (_, _, b)) in enumerate(hands))
end

function jokereq(c1, c2)
    if c1 == 11 || c2 == 11
        true
    else
        c1 == c2
    end
end

function find_hand_type_J(hand)
    counts = SVector(find_hand_counts_J(hand))

    nJ = counts[1]
    counts = setindex(counts, 0, 1)
    counts = sort(counts, rev=true)

    function find_type_rec(nJ, counts)
        if nJ == 0
            find_hand_type_counts(counts)
        else
            best = find_hand_type_counts(counts)
            for i in 1:2
                new_counts = setindex(counts, counts[i] + 1, i)
                best = max(best, find_type_rec(nJ - 1, new_counts))
            end
            best
        end
    end

    find_type_rec(nJ, counts)
end

function is_hand_less_joker(hand1, hand2)
    (find_hand_type_J(hand1), hand1) <
    (find_hand_type_J(hand2), hand2)
end

function tocardnumJ(c)
    if isdigit(c)
        c - '0'
    elseif c == 'T'
        10
    elseif c == 'J'
        1
    elseif c == 'Q'
        11
    elseif c == 'K'
        12
    elseif c == 'A'
        13
    else
        throw("Illegal card!")
    end
end

function find_hand_counts_J(hand)
    counts = @MVector [0 for _ in 1:13]

    for c in hand
        counts[c] += 1
    end

    counts
end

function part2()
    hands = Tuple{Int,SVector{5,Int},Int}[]

    open("$(homedir())/aoc-input/2023/day7/input") do io
        for l in eachline(io)
            h, b = eachsplit(l)
            hand = SVector((tocardnumJ(c) for c in h)...)
            b = parse(Int, b)

            push!(hands, (find_hand_type_J(hand), hand, b))
        end
    end

    sort!(hands)

    sum(b * i for (i, (_, _, b)) in enumerate(hands))
end
