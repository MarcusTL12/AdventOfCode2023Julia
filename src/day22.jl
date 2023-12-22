
function make_occupancy(bricks)
    occupancy = Dict{NTuple{3,Int},Int}()

    for (i, (xs, ys, zs)) in enumerate(bricks)
        for x in xs, y in ys, z in zs
            occupancy[(x, y, z)] = i
        end
    end

    occupancy
end

function make_bricks_fall!(bricks, occ)
    done = false

    which_fell = Set{Int}()

    while !done
        done = true

        for i in eachindex(bricks)
            (xs, ys, zs) = bricks[i]
            if all(!haskey(occ, (x, y, minimum(zs) - 1)) && minimum(zs) > 1
                   for x in xs, y in ys)
                for x in xs, y in ys
                    delete!(occ, (x, y, maximum(zs)))
                    occ[(x, y, minimum(zs) - 1)] = i
                    done = false
                    bricks[i] = (xs, ys, (minimum(zs)-1):(maximum(zs)-1))
                    push!(which_fell, i)
                end
            end
        end
    end

    length(which_fell)
end

function count_disintegratable(bricks, occ)
    n = 0

    for (i, (xs, ys, zs)) in enumerate(bricks)
        can_disintegrate = true
        for x in xs, y in ys
            if haskey(occ, (x, y, maximum(zs) + 1))
                xs2, ys2, zs2 = bricks[occ[(x, y, maximum(zs) + 1)]]
                if !any(haskey(occ, (x2, y2, minimum(zs2) - 1)) &&
                        occ[(x2, y2, minimum(zs2) - 1)] != i
                        for x2 in xs2, y2 in ys2)
                    can_disintegrate = false
                end
            end
        end

        if can_disintegrate
            n += 1
        end
    end

    n
end

function part1()
    bricks = []

    open("$(homedir())/aoc-input/2023/day22/input") do io
        for l in eachline(io)
            a, b = eachsplit(l, '~')

            x1, y1, z1 = parse.(Int, eachsplit(a, ','))
            x2, y2, z2 = parse.(Int, eachsplit(b, ','))

            @assert x1 <= x2
            @assert y1 <= y2
            @assert z1 <= z2

            push!(bricks, (x1:x2, y1:y2, z1:z2))
        end
    end

    occ = make_occupancy(bricks)

    make_bricks_fall!(bricks, occ)

    count_disintegratable(bricks, occ)
end

function disintegrate_brick(bricks, occ, i)
    occ = deepcopy(occ)
    xs, ys, zs = bricks[i]
    for x in xs, y in ys, z in zs
        delete!(occ, (x, y, z))
    end

    bricks = [bricks[j] for j in eachindex(bricks) if j != i]

    make_bricks_fall!(bricks, occ)
end

function part2()
    bricks = []

    open("$(homedir())/aoc-input/2023/day22/input") do io
        for l in eachline(io)
            a, b = eachsplit(l, '~')

            x1, y1, z1 = parse.(Int, eachsplit(a, ','))
            x2, y2, z2 = parse.(Int, eachsplit(b, ','))

            @assert x1 <= x2
            @assert y1 <= y2
            @assert z1 <= z2

            push!(bricks, (x1:x2, y1:y2, z1:z2))
        end
    end

    occ = make_occupancy(bricks)

    make_bricks_fall!(bricks, occ)

    sum(disintegrate_brick(bricks, occ, i) for i in eachindex(bricks))
end
