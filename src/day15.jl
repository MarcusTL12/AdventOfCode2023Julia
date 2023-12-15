
function do_hash(s)
    curval = 0

    for c in s
        curval += Int(c)
        curval *= 17
        curval %= 256
    end

    curval
end

function part1()
    inp = open("$(homedir())/aoc-input/2023/day15/input") do io
        first(eachline(io))
    end

    sum(do_hash, eachsplit(inp, ','))
end

function part2()
    inp = open("$(homedir())/aoc-input/2023/day15/input") do io
        first(eachline(io))
    end

    m = [Dict{SubString{String},NTuple{2,Int}}() for _ in 0:255]

    for entry in eachsplit(inp, ',')
        if endswith(entry, '-')
            k = entry[1:end-1]
            h = do_hash(k) + 1

            delete!(m[h], k)
        else
            k, v = split(entry, '=')
            v = parse(Int, v)
            h = do_hash(k) + 1

            if haskey(m[h], k)
                n, _ = m[h][k]
                m[h][k] = (n, v)
            elseif isempty(m[h])
                m[h][k] = (1, v)
            else
                m[h][k] = (maximum(x for (x, _) in values(m[h])) + 1, v)
            end
        end
    end


    sum(i * j * y
        for (i, v) in enumerate(m)
        for (j, (_, y)) in enumerate(sort!(collect(values(v)))))
end
