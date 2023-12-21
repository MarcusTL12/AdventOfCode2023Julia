
function part1()
    w = 0
    h = 0

    grid = Char[]

    open("$(homedir())/aoc-input/2023/day21/input") do io
        for l in eachline(io)
            w = length(l)
            h += 1
            append!(grid, l)
        end
    end

    grid = reshape(grid, w, h)

    pos = (0, 0)

    for y in 1:h, x in 1:w
        if grid[x, y] == 'S'
            pos = (x, y)
        end
    end

    queue = [(pos, 0)]
    inqueue = Set([pos])

    dirs = ((1, 0), (0, 1), (-1, 0), (0, -1))

    while queue[1][2] < 64
        pos, l = popfirst!(queue)
        delete!(inqueue, pos)

        for d in dirs
            npos = pos .+ d
            if get(grid, npos, '#') != '#' && npos ∉ inqueue
                push!(queue, (npos, l + 1))
                push!(inqueue, npos)
            end
        end
    end

    length(queue), length(inqueue)
end

function part2()
    w = 0
    h = 0

    grid = Char[]

    open("$(homedir())/aoc-input/2023/day21/ex1") do io
        for l in eachline(io)
            w = length(l)
            h += 1
            append!(grid, l)
        end
    end

    grid = reshape(grid, w, h)

    pos = (0, 0)

    for y in 1:h, x in 1:w
        if grid[x, y] == 'S'
            pos = (x, y)
        end
    end

    queue = [(pos, 0)]
    seen = Dict([pos => 0])

    dirs = ((1, 0), (0, 1), (-1, 0), (0, -1))

    while !isempty(queue)
        pos, l = popfirst!(queue)

        for d in dirs
            npos = pos .+ d
            if get(grid, (mod1.(npos, (w, h))), '#') != '#' && !haskey(seen, npos) && l < 5000
                push!(queue, (npos, l + 1))
                seen[npos] = l + 1
            end
        end
    end

    count(iseven, values(seen))
end
