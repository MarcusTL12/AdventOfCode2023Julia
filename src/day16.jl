
Base.adjoint(c::Char) = c

function find_energized(grid, pos, dir)
    w, h = size(grid)

    energized = zeros(Int, w, h)

    light_beams = [(pos, dir)]

    dirs = ((1, 0), (0, 1), (-1, 0), (0, -1))

    while !isempty(light_beams)
        pos, dir = pop!(light_beams)

        while all(pos .<= (w, h)) && all(pos .>= 1) && (energized[pos...] & 2^dir == 0) && grid[pos...] == '.'
            energized[pos...] |= 2^dir
            pos = pos .+ dirs[dir]
        end

        if all(pos .<= (w, h)) && all(pos .>= 1)
            if grid[pos...] == '|'
                if dir == 2 || dir == 4
                    energized[pos...] |= 2^dir
                    pos = pos .+ dirs[dir]
                    push!(light_beams, (pos, dir))
                else
                    energized[pos...] |= 2^2 | 2^4
                    pos2 = pos .+ dirs[2]
                    pos4 = pos .+ dirs[4]
                    push!(light_beams, (pos2, 2))
                    push!(light_beams, (pos4, 4))
                end
            elseif grid[pos...] == '-'
                if dir == 1 || dir == 3
                    energized[pos...] |= 2^dir
                    pos = pos .+ dirs[dir]
                    push!(light_beams, (pos, dir))
                else
                    energized[pos...] |= 2^1 | 2^3
                    pos1 = pos .+ dirs[1]
                    pos3 = pos .+ dirs[3]
                    push!(light_beams, (pos1, 1))
                    push!(light_beams, (pos3, 3))
                end
            elseif grid[pos...] != '.'
                ndir = if grid[pos...] == '/'
                    if dir == 1
                        4
                    elseif dir == 2
                        3
                    elseif dir == 3
                        2
                    elseif dir == 4
                        1
                    end
                elseif grid[pos...] == '\\'
                    if dir == 1
                        2
                    elseif dir == 2
                        1
                    elseif dir == 3
                        4
                    elseif dir == 4
                        3
                    end
                end

                energized[pos...] |= 2^dir
                pos = pos .+ dirs[ndir]
                push!(light_beams, (pos, ndir))
            end
        end
    end

    count(!iszero, energized)
end

function part1()
    w = 0
    h = 0

    grid = Char[]

    open("$(homedir())/aoc-input/2023/day16/input") do io
        for l in eachline(io)
            w = length(l)
            h += 1
            append!(grid, l)
        end
    end

    grid = reshape(grid, w, h)

    find_energized(grid, (1, 1), 1)
end

function part2()
    w = 0
    h = 0

    grid = Char[]

    open("$(homedir())/aoc-input/2023/day16/input") do io
        for l in eachline(io)
            w = length(l)
            h += 1
            append!(grid, l)
        end
    end

    grid = reshape(grid, w, h)

    z = 0

    for y in 1:h
        a = find_energized(grid, (1, y), 1)
        b = find_energized(grid, (w, y), 3)

        z = max(a, b, z)
    end

    for x in 1:w
        a = find_energized(grid, (x, 1), 2)
        b = find_energized(grid, (x, h), 4)

        z = max(a, b, z)
    end

    z
end
