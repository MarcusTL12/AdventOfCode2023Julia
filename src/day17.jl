using DataStructures

function part1()
    w = 0
    h = 0

    grid = Char[]

    open("$(homedir())/aoc-input/2023/day17/input") do io
        for l in eachline(io)
            w = length(l)
            h += 1
            append!(grid, l)
        end
    end

    grid = reshape(grid, w, h)

    queue = PriorityQueue(((1, 1), 1, 0) => 0, ((1, 1), 2, 0) => 0)
    seen = Set((((1, 1), 1, 0), ((1, 1), 2, 0)))

    dirs = ((1, 0), (0, 1), (-1, 0), (0, -1))

    function isinbounds((x, y),)
        1 <= x <= w && 1 <= y <= h
    end

    function enqueuemin!(k, v)
        if haskey(queue, k)
            queue[k] = min(queue[k], v)
        else
            queue[k] = v
        end
    end

    while !isempty(queue)
        (pos, dir, nstraight), heatloss = dequeue_pair!(queue)
        push!(seen, (pos, dir, nstraight))

        if pos == (w, h)
            return heatloss
        end

        if nstraight < 3
            npos = pos .+ dirs[dir]
            k = (npos, dir, nstraight + 1)
            if isinbounds(npos) && k ∉ seen
                enqueuemin!(k, heatloss + (grid[npos...] - '0'))
            end
        end

        for dirchange in (-1, 1)
            ndir = mod1(dir + dirchange, 4)
            npos = npos = pos .+ dirs[ndir]
            k = (npos, ndir, 1)
            if isinbounds(npos) && k ∉ seen
                enqueuemin!(k, heatloss + (grid[npos...] - '0'))
            end
        end
    end
end

function part2()
    w = 0
    h = 0

    grid = Char[]

    open("$(homedir())/aoc-input/2023/day17/input") do io
        for l in eachline(io)
            w = length(l)
            h += 1
            append!(grid, l)
        end
    end

    grid = reshape(grid, w, h)

    queue = PriorityQueue(((1, 1), 1, 0) => 0, ((1, 1), 2, 0) => 0)
    seen = Set((((1, 1), 1, 0), ((1, 1), 2, 0)))

    dirs = ((1, 0), (0, 1), (-1, 0), (0, -1))

    function isinbounds((x, y),)
        1 <= x <= w && 1 <= y <= h
    end

    function enqueuemin!(k, v)
        if haskey(queue, k)
            queue[k] = min(queue[k], v)
        else
            queue[k] = v
        end
    end

    while !isempty(queue)
        (pos, dir, nstraight), heatloss = dequeue_pair!(queue)
        push!(seen, (pos, dir, nstraight))

        if pos == (w, h) && nstraight >= 4
            return heatloss
        end

        if nstraight < 10
            npos = pos .+ dirs[dir]
            k = (npos, dir, nstraight + 1)
            if isinbounds(npos) && k ∉ seen
                enqueuemin!(k, heatloss + (grid[npos...] - '0'))
            end
        end

        if nstraight >= 4
            for dirchange in (-1, 1)
                ndir = mod1(dir + dirchange, 4)
                npos = npos = pos .+ dirs[ndir]
                k = (npos, ndir, 1)
                if isinbounds(npos) && k ∉ seen
                    enqueuemin!(k, heatloss + (grid[npos...] - '0'))
                end
            end
        end
    end
end
