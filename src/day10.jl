
function part1()

    n = 0
    m = 0

    grid = Char[]

    open("$(homedir())/aoc-input/2023/day10/input") do io
        for l in eachline(io)
            n = length(l)
            m += 1
            append!(grid, l)
        end
    end

    grid = reshape(grid, n, m)

    display(grid')

    start = (0, 0)

    for y in 1:m, x in 1:n
        if grid[x, y] == 'S'
            start = (x, y)
            break
        end
    end

    connect_map = Dict((
        '-' => ((-1, 0), (1, 0)),
        '|' => ((0, -1), (0, 1)),
        '7' => ((-1, 0), (0, 1)),
        'J' => ((-1, 0), (0, -1)),
        'L' => ((1, 0), (0, -1)),
        'F' => ((1, 0), (0, 1)),
    ))

    @show start

    starts = []

    for d in ((1, 0), (-1, 0), (0, 1), (0, -1))
        np = start .+ d
        if (0 .- d) ∈ get(connect_map, get(grid, np, '.'), ())
            push!(starts, (np, d))
        end
    end

    (p1, d1), (p2, d2) = starts

    steps = 1

    function do_step(p, d)
        c1, c2 = connect_map[grid[p...]]

        nd = (0 .- d) == c1 ? c2 : c1

        p .+ nd, nd
    end

    while p1 != p2
        # @show p1, d1 p2, d2
        # println()
        p1, d1 = do_step(p1, d1)
        p2, d2 = do_step(p2, d2)
        steps += 1
    end

    steps
end

function part2()

    n = 0
    m = 0

    grid = Char[]

    open("$(homedir())/aoc-input/2023/day10/input") do io
        for l in eachline(io)
            n = length(l)
            m += 1
            append!(grid, l)
        end
    end

    grid = reshape(grid, n, m)

    start = (0, 0)

    for y in 1:m, x in 1:n
        if grid[x, y] == 'S'
            start = (x, y)
            break
        end
    end

    connect_map = Dict((
        '-' => ((-1, 0), (1, 0)),
        '|' => ((0, -1), (0, 1)),
        '7' => ((-1, 0), (0, 1)),
        'J' => ((-1, 0), (0, -1)),
        'L' => ((1, 0), (0, -1)),
        'F' => ((1, 0), (0, 1)),
    ))

    starts = []

    for d in ((1, 0), (-1, 0), (0, 1), (0, -1))
        np = start .+ d
        if (0 .- d) ∈ get(connect_map, get(grid, np, '.'), ())
            push!(starts, (np, d))
        end
    end

    (p1, d1), (p2, d2) = starts

    function do_step(p, d)
        c1, c2 = connect_map[grid[p...]]

        nd = (0 .- d) == c1 ? c2 : c1

        p .+ nd, nd
    end

    loop = [start, p1, p2]

    inouts = [falses(size(grid)), falses(size(grid))]

    while p1 != p2
        np1, nd1 = do_step(p1, d1)
        np2, nd2 = do_step(p2, d2)

        io_n = 1
        dir = Complex{Int}(nd1...)
        for _ in 1:3
            dir *= im
            if (real(dir), imag(dir)) == (0 .- d1)
                io_n = 2
            else
                np = p1 .+ (real(dir), imag(dir))
                if all(np .>= 1) && all(np .<= (n, m))
                    inouts[io_n][np...] = true
                end
            end
        end

        io_n = 2
        dir = Complex{Int}(nd2...)
        for _ in 1:3
            dir *= im
            if (real(dir), imag(dir)) == (0 .- d2)
                io_n = 1
            else
                np = p2 .+ (real(dir), imag(dir))
                if all(np .>= 1) && all(np .<= (n, m))
                    inouts[io_n][np...] = true
                end
            end
        end

        p1 = np1
        p2 = np2
        d1 = nd1
        d2 = nd2

        push!(loop, p1)
        push!(loop, p2)
    end

    for p in loop
        inouts[1][p...] = false
        inouts[2][p...] = false
    end

    edge = falses(size(grid))

    for x in 1:n
        edge[x, 1] = true
        edge[x, end] = true
    end

    for y in 1:m
        edge[1, y] = true
        edge[end, y] = true
    end

    move_stacks = [Tuple{Int,Int}[], Tuple{Int,Int}[]]

    for y in 1:m, x in 1:n, i in 1:2
        if inouts[i][x, y]
            push!(move_stacks[i], (x, y))
        end
    end

    for i in 1:2
        while !isempty(move_stacks[i])
            p = pop!(move_stacks[i])
            for d in ((1, 0), (-1, 0), (0, 1), (0, -1))
                np = p .+ d
                if all(np .<= (n, m)) && all(np .>= 1) && !inouts[i][np...] && np ∉ loop
                    inouts[i][np...] = true
                    push!(move_stacks[i], np)
                end
            end
        end
    end

    if any(inouts[1] .& edge)
        count(inouts[2])
    else
        count(inouts[1])
    end
end
