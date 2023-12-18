
function part1()
    pos = (0, 0)

    trench = Dict((pos => 1,))

    open("$(homedir())/aoc-input/2023/day18/input") do io
        for l in eachline(io)
            dir, n, _ = eachsplit(l)

            n = parse(Int, n)

            for _ in 1:n
                pos = pos .+ if dir == "R"
                    (1, 0)
                elseif dir == "D"
                    (0, 1)
                elseif dir == "L"
                    (-1, 0)
                elseif dir == "U"
                    (0, -1)
                end

                trench[pos] = 1
            end
        end
    end

    minx, maxx = extrema(x for (x, _) in keys(trench))
    miny, maxy = extrema(y for (_, y) in keys(trench))

    minx -= 1
    maxx += 1
    miny -= 1
    maxy += 1

    queue = []

    for x in minx:maxx
        push!(queue, (x, miny))
        push!(queue, (x, maxy))
    end

    for y in miny:maxy
        push!(queue, (minx, y))
        push!(queue, (maxx, y))
    end

    dirs = ((1, 0), (0, 1), (-1, 0), (0, -1))

    while !isempty(queue)
        pos = pop!(queue)

        if !haskey(trench, pos)
            trench[pos] = 2

            for dir in dirs
                npos = pos .+ dir
                if all(npos .>= (minx, miny)) && all(npos .<= (maxx, maxy))
                    push!(queue, npos)
                end
            end
        end
    end

    count(get(trench, (x, y), 1) == 1 for x in minx:maxx, y in miny:maxy)
end

function part2()
    pos = (0, 0)

    vertices = NTuple{2,Int}[]

    dirs = ((1, 0), (0, 1), (-1, 0), (0, -1))

    perimeter = 0

    open("$(homedir())/aoc-input/2023/day18/input") do io
        for l in eachline(io)
            _, _, hex = eachsplit(l)

            n = parse(Int, "0x" * hex[3:end-1])

            n, d = divrem(n, 16)

            pos = pos .+ n .* dirs[d+1]

            perimeter += n

            push!(vertices, pos)
        end
    end

    area = 0

    for i in 1:length(vertices)-1
        area += vertices[i][1] * vertices[i+1][2] -
                vertices[i][2] * vertices[i+1][1]
    end

    (area + perimeter) ÷ 2 + 1
end
