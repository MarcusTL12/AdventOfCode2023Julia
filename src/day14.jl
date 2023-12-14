
function fall_up!(grid)
    m, n = size(grid)

    done = false

    while !done
        done = true
        for y in 2:n, x in 1:m
            if grid[x, y] == 'O' && grid[x, y-1] == '.'
                grid[x, y] = '.'
                grid[x, y-1] = 'O'
                done = false
            end
        end
    end
end

function part1()
    n = 0
    m = 0

    grid = Char[]

    open("$(homedir())/aoc-input/2023/day14/input") do io
        for l in eachline(io)
            n = length(l)
            m += 1
            append!(grid, l)
        end
    end

    grid = reshape(grid, n, m)

    fall_up!(grid)

    load = 0

    for y in 1:n, x in 1:m
        if grid[x, y] == 'O'
            load += n - (y - 1)
        end
    end

    load
end

Base.adjoint(c::Char) = c

function do_cycle!(grid)
    fall_up!(grid)
    fall_up!(grid')
    fall_up!(@view grid[:, end:-1:1])
    fall_up!((@view grid[end:-1:1, :])')
end

function part2()
    n = 0
    m = 0

    grid = Char[]

    open("$(homedir())/aoc-input/2023/day14/input") do io
        for l in eachline(io)
            n = length(l)
            m += 1
            append!(grid, l)
        end
    end

    grid = reshape(grid, n, m)

    seen_grids = Dict{UInt64,Int}(hash(grid) => 0)

    loop_start = -1
    loop_end = -1

    for i in 1:1000_000_000
        do_cycle!(grid)
        hgrid = hash(grid)
        if haskey(seen_grids, hgrid)
            loop_start = seen_grids[hgrid]
            loop_end = i
            break
        else
            seen_grids[hgrid] = i
        end
    end

    loop_len = loop_end - loop_start
    rem_cycles = 1000_000_000 - loop_start
    rem_loop = rem_cycles % loop_len

    for _ in 1:rem_loop
        do_cycle!(grid)
    end

    load = 0

    for y in 1:n, x in 1:m
        if grid[x, y] == 'O'
            load += n - (y - 1)
        end
    end

    load
end
