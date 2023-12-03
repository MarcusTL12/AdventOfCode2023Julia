
function part1()
    n = 0
    m = 0

    grid = Char[]

    open("$(homedir())/aoc-input/2023/day3/input") do io
        for l in eachline(io)
            n = length(l)
            m += 1
            append!(grid, l)
        end
    end

    grid = reshape(grid, n, m)

    part_numbers = []

    parsing_num = false
    found_symbol = false
    num = 0

    for y in 1:m, x in 1:n+1
        if !parsing_num && isdigit(get(grid, (x, y), '.'))
            parsing_num = true
            found_symbol = any(get(grid, (x, y) .+ d, '.') != '.'
                               for d in [
                (-1, 0), (-1, 1), (-1, -1), (0, -1), (0, 1)
            ])
            num = get(grid, (x, y), '.') - '0'
        elseif parsing_num && isdigit(get(grid, (x, y), '.'))
            found_symbol |= any(get(grid, (x, y) .+ d, '.') != '.'
                                for d in [(0, -1), (0, 1)])
            num = 10num + (get(grid, (x, y), '.') - '0')
        elseif parsing_num
            found_symbol |= any(get(grid, (x, y) .+ d, '.') != '.'
                                for d in [(0, -1), (0, 1), (0, 0)])
            if found_symbol
                push!(part_numbers, num)
            end
            parsing_num = false
        end
    end

    sum(part_numbers)
end

function part2()
    lx = 0
    ly = 0

    grid = Char[]

    open("$(homedir())/aoc-input/2023/day3/input") do io
        for l in eachline(io)
            lx = length(l)
            ly += 1
            append!(grid, l)
        end
    end

    grid = reshape(grid, lx, ly)


    function find_start_of_num(x, y)
        while isdigit(get(grid, (x - 1, y), '.'))
            x -= 1
        end
        x
    end

    function parse_number(x, y)
        n = 0
        while isdigit(get(grid, (x, y), '.'))
            n = 10n + (get(grid, (x, y), '.') - '0')
            x += 1
        end
        n
    end

    dirs = [
        (1, 0),
        (-1, 0),
        (0, 1),
        (0, -1),
        (1, 1),
        (-1, 1),
        (-1, -1),
        (1, -1),
    ]

    res = 0

    for i in 1:ly, j in 1:lx
        if grid[j, i] == '*'
            adjacent = []
            for d in dirs
                nx, ny = (j, i) .+ d
                if isdigit(get(grid, (nx, ny), '.'))
                    nx = find_start_of_num(nx, ny)
                    push!(adjacent, (nx, ny))
                end
            end

            unique!(adjacent)
            if length(adjacent) == 2
                res += prod(parse_number(x, y) for (x, y) in adjacent)
            end
        end
    end

    res
end
