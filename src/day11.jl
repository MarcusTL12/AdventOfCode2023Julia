using DataStructures

function part1()

    n = 0
    m = 0

    grid = Char[]

    open("$(homedir())/aoc-input/2023/day11/input") do io
        for l in eachline(io)
            n = length(l)
            m += 1
            append!(grid, l)
        end
    end

    grid = reshape(grid, n, m)

    galaxies = Tuple{Int,Int}[]

    for y in 1:m, x in 1:m
        if grid[x, y] == '#'
            push!(galaxies, (x, y))
        end
    end

    s = 0

    for (i, (x1, y1)) in enumerate(galaxies)
        for (x2, y2) in (@view galaxies[i+1:end])
            mandist = abs(x2 - x1) + abs(y2 - y1)

            extra_xdist = count(all(==('.'), (@view grid[x, :]))
                                for x in min(x1, x2):max(x1, x2))

            extra_ydist = count(all(==('.'), (@view grid[:, y]))
                                for y in min(y1, y2):max(y1, y2))

            s += mandist + extra_xdist + extra_ydist
        end
    end

    s
end

function part2()

    n = 0
    m = 0

    grid = Char[]

    open("$(homedir())/aoc-input/2023/day11/input") do io
        for l in eachline(io)
            n = length(l)
            m += 1
            append!(grid, l)
        end
    end

    grid = reshape(grid, n, m)

    galaxies = Tuple{Int,Int}[]

    for y in 1:m, x in 1:m
        if grid[x, y] == '#'
            push!(galaxies, (x, y))
        end
    end

    s = 0

    for (i, (x1, y1)) in enumerate(galaxies)
        for (x2, y2) in (@view galaxies[i+1:end])
            mandist = abs(x2 - x1) + abs(y2 - y1)

            extra_xdist = count(all(==('.'), (@view grid[x, :]))
                                for x in min(x1, x2):max(x1, x2)) * (1000000 - 1)

            extra_ydist = count(all(==('.'), (@view grid[:, y]))
                                for y in min(y1, y2):max(y1, y2)) * (1000000 - 1)

            s += mandist + extra_xdist + extra_ydist
        end
    end

    s
end
