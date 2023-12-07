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

function fiveeq(hand)
    if allequal(hand)
        true, hand[1]
    else
        false, 0
    end
end

function foureq(hand)
    if allequal(@view hand[1:4]) || allequal(@view hand[2:5])
        true, hand[3]
    else
        false, 0
    end
end

function fullhouse(hand)
    if allequal(@view hand[1:3]) && hand[4] == hand[5] ||
       hand[1] == hand[2] && allequal(@view hand[3:5])
        true, (hand[1], hand[5])
    else
        false, (0, 0)
    end
end

function threeq(hand)
    if allequal(@view hand[1:3]) || allequal(@view hand[2:4]) ||
       allequal(@view hand[3:5])
        true, hand[3]
    else
        false, 0
    end
end

function twopair(hand)
    if hand[1] == hand[2] && (hand[3] == hand[4] || hand[4] == hand[5]) ||
       hand[2] == hand[3] && hand[4] == hand[5]
        true, (hand[2], hand[4])
    else
        false, (0, 0)
    end
end

function onepair(hand)
    for i in 1:4
        if hand[i] == hand[i+1]
            return true, hand[i]
        end
    end
    false, 0
end

function highcard(hand)
    true, maximum(hand)
end

function find_hand_type(hand)
    t = 7
    hand = sort(hand)
    for f in (fiveeq, foureq, fullhouse, threeq, twopair, onepair, highcard)
        if f(hand)[1]
            return t
        end
        t -= 1
    end
    t
end

function is_hand_less(hand1, hand2)
    (find_hand_type(hand1), hand1) < (find_hand_type(hand2), hand2)
end

function part1()
    hands = Tuple{SVector{5,Int},Int}[]

    open("$(homedir())/aoc-input/2023/day7/input") do io
        for l in eachline(io)
            h, b = eachsplit(l)
            hand = SVector((tocardnum(c) for c in h)...)
            b = parse(Int, b)

            push!(hands, (hand, b))
        end
    end

    sort!(hands, lt=((h1, _), (h2, _)) -> is_hand_less(h1, h2))

    sum(b * i for (i, (_, b)) in enumerate(hands))
end
