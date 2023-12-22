using Polynomials

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

function get_plots_n(grid, pos, n)
    queue = [(pos, 0)]
    seen = Dict([pos => 0])

    dirs = ((1, 0), (0, 1), (-1, 0), (0, -1))

    while !isempty(queue)
        pos, l = popfirst!(queue)

        for d in dirs
            npos = pos .+ d
            if get(grid, npos, '#') != '#' && !haskey(seen, npos) && l < n
                push!(queue, (npos, l + 1))
                seen[npos] = l + 1
            end
        end
    end

    count(l % 2 == n % 2 for l in values(seen))
end

function get_num_until_full(grid, pos)
    queue = [(pos, 0)]
    seen = Dict([pos => 0])

    dirs = ((1, 0), (0, 1), (-1, 0), (0, -1))

    last_l = 0

    while !isempty(queue)
        pos, l = popfirst!(queue)

        last_l = l

        for d in dirs
            npos = pos .+ d
            if get(grid, npos, '#') != '#' && !haskey(seen, npos)
                push!(queue, (npos, l + 1))
                seen[npos] = l + 1
            end
        end
    end

    last_l
end

function part2()
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

    start_pos = (0, 0)

    for y in 1:h, x in 1:w
        if grid[x, y] == 'S'
            start_pos = (x, y)
        end
    end

    n_steps_total = 26501365

    function find_for_nw(nw)
        n_steps = n_steps_total % w + w * nw

        queue = [(start_pos, 0)]
        seen = Dict([start_pos => 0])

        dirs = ((1, 0), (0, 1), (-1, 0), (0, -1))

        while !isempty(queue)
            pos, l = popfirst!(queue)

            for d in dirs
                npos = pos .+ d
                if get(grid, (mod1.(npos, (w, h))), '#') != '#' &&
                   !haskey(seen, npos) && l < n_steps
                    push!(queue, (npos, l + 1))
                    seen[npos] = l + 1
                end
            end
        end

        count(iseven(x + n_steps) for x in values(seen))
    end

    xs = 0:2
    ys = find_for_nw.(xs)

    @show ys

    pol = fit(Polynomial{Int}, xs, ys)

    @show pol

    pol(n_steps_total ÷ w)
end

function part2_attempt_1()
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

    @assert w == h
    @assert pos[1] == pos[2]
    @assert (w - 1) ÷ 2 == pos[1] - 1
    @assert isodd(w)

    dist_first = pos[1]

    n_steps = 26501365

    @show steps_left_lateral = n_steps - dist_first
    @show steps_left_diag = steps_left_lateral - dist_first

    @show n_lateral_reached = steps_left_lateral ÷ w + 1
    @show n_diag_reached = steps_left_diag ÷ w + 1

    @show steps_rem_lateral_1 = steps_left_lateral % w
    @show steps_rem_lateral_2 = steps_left_lateral % w + w

    @show steps_rem_diag_1 = steps_left_diag % w
    @show steps_rem_diag_2 = steps_left_diag % w + w

    n_plots_even = count(iseven, (x + y for x in 1:w, y in 1:h if grid[x, y] != '#'))
    n_plots_odd = count(isodd, (x + y for x in 1:w, y in 1:h if grid[x, y] != '#'))

    @show n_plots_full = [n_plots_even, n_plots_odd]

    @show middle_full = n_plots_full[(pos[1]+pos[2]+n_steps)%2+1]
    @show lateral_full_1, lateral_full_2 = n_plots_full[[
        (pos[1] + 1 + steps_left_lateral) % 2 + 1,
        (pos[1] + 1 + steps_left_lateral + w) % 2 + 1]]
    @show diag_full_1, diag_full_2 = n_plots_full[[
        (1 + 1 + steps_left_lateral) % 2 + 1,
        (1 + 1 + steps_left_lateral + w) % 2 + 1]]

    @show n_lateral_full_1 = cld(n_lateral_reached - 2, 2) * 4
    @show n_lateral_full_2 = fld(n_lateral_reached - 2, 2) * 4
    @show n_diag_full_1 = sum(1:2:(n_diag_reached-2)) * 4
    @show n_diag_full_2 = sum(2:2:(n_diag_reached-2)) * 4

    all_full = middle_full +
               lateral_full_1 * n_lateral_full_1 + diag_full_1 * n_diag_full_1 +
               lateral_full_2 * n_lateral_full_2 + diag_full_2 * n_diag_full_2

    lateral_right_1 = get_plots_n(grid, (1, pos[2]), steps_rem_lateral_1)
    lateral_right_2 = get_plots_n(grid, (1, pos[2]), steps_rem_lateral_2)

    lateral_left_1 = get_plots_n(grid, (w, pos[2]), steps_rem_lateral_1)
    lateral_left_2 = get_plots_n(grid, (w, pos[2]), steps_rem_lateral_2)

    lateral_up_1 = get_plots_n(grid, (pos[1], 1), steps_rem_lateral_1)
    lateral_up_2 = get_plots_n(grid, (pos[1], 1), steps_rem_lateral_2)

    lateral_down_1 = get_plots_n(grid, (pos[1], w), steps_rem_lateral_1)
    lateral_down_2 = get_plots_n(grid, (pos[1], w), steps_rem_lateral_2)

    diag_upright_1 = get_plots_n(grid, (1, 1), steps_rem_diag_1)
    diag_upright_2 = get_plots_n(grid, (1, 1), steps_rem_diag_2)

    diag_upleft_1 = get_plots_n(grid, (w, 1), steps_rem_diag_1)
    diag_upleft_2 = get_plots_n(grid, (w, 1), steps_rem_diag_2)

    diag_downright_1 = get_plots_n(grid, (1, w), steps_rem_diag_1)
    diag_downright_2 = get_plots_n(grid, (1, w), steps_rem_diag_2)

    diag_downleft_1 = get_plots_n(grid, (w, w), steps_rem_diag_1)
    diag_downleft_2 = get_plots_n(grid, (w, w), steps_rem_diag_2)

    n_diag_1 = n_diag_reached
    n_diag_2 = (n_diag_reached - 1)

    all_1 = lateral_right_1 + lateral_left_1 + lateral_up_1 + lateral_down_1 +
            (diag_upright_1 + diag_upleft_1 + diag_downright_1 + diag_downleft_1) * n_diag_1

    all_2 = lateral_right_2 + lateral_left_2 + lateral_up_2 + lateral_down_2 +
            (diag_upright_2 + diag_upleft_2 + diag_downright_2 + diag_downleft_2) * n_diag_2

    all_full + all_1 + all_2
end
