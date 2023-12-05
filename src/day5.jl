
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
    inp = open(String ∘ read, "$(homedir())/aoc-input/2023/day5/input")

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

function map_range(rng, map_rng)
    (dstart, sstart, l) = map_rng
    
end

function part2_smart()
    inp = open(String ∘ read, "$(homedir())/aoc-input/2023/day5/input")

    blocks = eachsplit(inp, "\n\n")

    seed_block, map_blocks = Iterators.peel(blocks)

    _, seeds = eachsplit(seed_block, ": ")
    seeds = parse.(Int, eachsplit(seeds))

    seeds = reshape(seeds, 2, length(seeds) ÷ 2)

    maps = parse_map.(map_blocks)
end
