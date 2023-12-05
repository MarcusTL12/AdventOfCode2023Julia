
function parse_map(block)
    # @show block

    firstline, rest = Iterators.peel(eachsplit(block, '\n'))

    m = 0
    n = 0

    mat = Int[]

    for l in rest
        if !isempty(l)
            n += 1
            s = split(l)
            m = length(s)
            append!(mat, parse(Int, x) for x in s)
        end
    end

    # @show m, n

    reshape(mat, m, n)
end

function map_number(src, mp)
    for (dstart, sstart, l) in eachcol(mp)
        srange = range(sstart, length=l)
        drange = range(dstart, length=l)

        if src ∈ srange
            i = src - sstart + 1
            return drange[i]
        end
    end
    src
end

function map_seed(seed, maps)
    for mp in maps
        seed = map_number(seed, mp)
    end
    seed
end

function part1()
    inp = open(String ∘ read, "$(homedir())/aoc-input/2023/day5/input")

    blocks = eachsplit(inp, "\n\n")

    seed_block, map_blocks = Iterators.peel(blocks)

    _, seeds = eachsplit(seed_block, ": ")
    seeds = parse.(Int, eachsplit(seeds))

    maps = parse_map.(map_blocks)

    locs = [map_seed(seed, maps) for seed in seeds]

    minimum(locs)
end

function part2()
    inp = open(String ∘ read, "$(homedir())/aoc-input/2023/day5/ex1")

    blocks = eachsplit(inp, "\n\n")

    seed_block, map_blocks = Iterators.peel(blocks)

    _, seeds = eachsplit(seed_block, ": ")
    seeds = parse.(Int, eachsplit(seeds))

    seeds = reshape(seeds, 2, length(seeds) ÷ 2)

    maps = parse_map.(map_blocks)

    minlocs = zeros(Int, size(seeds, 2))

    Threads.@threads for i in axes(seeds, 2)
        (sstart, l) = @view seeds[:, i]
        sr = range(sstart, length=l)

        x = @time minimum(map_seed(seed, maps) for seed in sr)

        minlocs[i] = x
    end

    minimum(minlocs)
end

@inline function rangediff(r1, r2)
    first(r1):min(last(r1), first(r2) - 1),
    max(first(r1), last(r2) + 1):last(r1)
end

function map_range(rng, map_rng)
    (dstart, sstart, l) = map_rng

    srange = range(sstart, length=l)
    drange = range(dstart, length=l)

    mapped_range = intersect(rng, srange)

    remleft, remright = rangediff(rng, mapped_range)

    ind_range = mapped_range .- (sstart - 1)

    dest_range = @inbounds drange[ind_range]

    remleft, remright, dest_range
end

function map_block(inp_ranges, mp)
    other_inp_ranges = eltype(inp_ranges)[]
    mapped_ranges = eltype(inp_ranges)[]

    for map_rng in eachcol(mp)
        empty!(other_inp_ranges)
        for inp_range in inp_ranges
            rem1, rem2, mapped = map_range(inp_range, map_rng)
            for rng in (rem1, rem2)
                if length(rng) > 0
                    push!(other_inp_ranges, rng)
                end
            end

            if length(mapped) > 0
                push!(mapped_ranges, mapped)
            end
        end
        inp_ranges, other_inp_ranges = other_inp_ranges, inp_ranges
    end

    append!(mapped_ranges, inp_ranges)
end

function part2_smart()
    inp = open(String ∘ read, "$(homedir())/aoc-input/2023/day5/input")

    blocks = eachsplit(inp, "\n\n")

    seed_block, map_blocks = Iterators.peel(blocks)

    _, seeds = eachsplit(seed_block, ": ")
    seeds = parse.(Int, eachsplit(seeds))

    seeds = reshape(seeds, 2, length(seeds) ÷ 2)

    seeds = [range(start, length=l) for (start, l) in eachcol(seeds)]

    maps = parse_map.(map_blocks)

    for mp in maps
        seeds = map_block(seeds, mp)
    end

    minimum(minimum, seeds)
end

function map_min(inp_range, mp, rest)
    if isempty(inp_range)
        return typemax(Int)
    end

    if size(mp, 2) == 0
        return if isempty(rest)
            minimum(inp_range)
        else
            map_min(inp_range, Iterators.peel(rest)...)
        end
    end

    map_rng = @view mp[:, 1]
    rest_mp = @view mp[:, 2:end]

    rem1, rem2, mapped = map_range(inp_range, map_rng)

    min1 = if isempty(mapped)
        typemax(Int)
    elseif isempty(rest)
        minimum(mapped)
    else
        map_min(mapped, Iterators.peel(rest)...)
    end

    min2 = map_min(rem1, rest_mp, rest)

    min3 = map_min(rem2, rest_mp, rest)

    min(min1, min2, min3)
end

function part2_smart2()
    inp = open(String ∘ read, "$(homedir())/aoc-input/2023/day5/input")

    blocks = eachsplit(inp, "\n\n")

    seed_block, map_blocks = Iterators.peel(blocks)

    _, seeds = eachsplit(seed_block, ": ")
    seeds = parse.(Int, eachsplit(seeds))

    seeds = reshape(seeds, 2, length(seeds) ÷ 2)

    seeds = [range(start, length=l) for (start, l) in eachcol(seeds)]

    maps = parse_map.(map_blocks)

    mp, rest = Iterators.peel(maps)

    minimum(map_min(seed, mp, rest) for seed in seeds)
end
