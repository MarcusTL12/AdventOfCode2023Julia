using PyCall

function part1()
    w = 0
    h = 0

    grid = Char[]

    open("$(homedir())/aoc-input/2023/day23/input") do io
        for l in eachline(io)
            w = length(l)
            h += 1
            append!(grid, l)
        end
    end

    grid = reshape(grid, w, h)

    dirs = ((1, 0), (0, 1), (-1, 0), (0, -1))
    allowed_dirs = (('>', 1), ('v', 2), ('<', 3), ('^', 4))

    function rec(path)
        pos = path[end]

        max_l = length(path)

        for i in 1:4
            d = dirs[i]

            np = pos .+ d

            if all(np .>= 1) && all(np .<= size(grid)) && grid[np...] != '#' &&
               np ∉ path &&
               (grid[np...] == '.' || (grid[np...], i) ∈ allowed_dirs)
                push!(path, np)
                l = rec(path)
                pop!(path)

                max_l = max(max_l, l)
            end
        end

        max_l
    end

    rec([(2, 1)]) - 1
end

function dfs_max(adj_mat, target)
    visited = falses(size(adj_mat, 1))

    max_l = 0

    function rec(path)
        pos = path[end]

        if pos == target
            l = 0
            for i in 1:length(path)-1
                l += adj_mat[path[i], path[i+1]]
            end

            if l > max_l
                max_l = l
                @show max_l
            end
        else
            visited[pos] = true

            for i in eachindex(visited)
                if !visited[i] && adj_mat[pos, i] != 0
                    push!(path, i)
                    rec(path)
                    pop!(path)
                end
            end

            visited[pos] = false
        end
    end

    rec([1])

    max_l
end

function build_graph_dfs(grid)
    nodes = NTuple{2,Int}[]
    edges = Dict{NTuple{2,NTuple{2,Int}},Int}()
    seen = Set{NTuple{2,Int}}()

    function edgekey(a, b)
        a < b ? (a, b) : (b, a)
    end

    function update_edge(a, b, l)
        k = edgekey(a, b)
        edges[k] = max(get(edges, k, 0), l)
    end

    dirs = ((1, 0), (0, 1), (-1, 0), (0, -1))

    function rec(pos, prev_node, l)
        if pos ∈ nodes
            if pos != nodes[prev_node]
                update_edge(pos, nodes[prev_node], l)
            end
        elseif pos ∉ seen
            c = 0
            for d in dirs
                npos = pos .+ d
                if get(grid, npos, '#') != '#'
                    c += 1
                end
            end

            if c != 2
                push!(nodes, pos)
                if length(nodes) > 1
                    update_edge(pos, nodes[prev_node], l)
                end
                l = 0
                prev_node = length(nodes)
            end

            push!(seen, pos)
            for i in 1:4
                d = dirs[i]

                np = pos .+ d

                if all(np .>= 1) && all(np .<= size(grid)) &&
                   grid[np...] != '#'
                    rec(np, prev_node, l + 1)
                end
            end
        end
    end

    rec((2, 1), 1, 0)

    nodes, edges
end

function part2_viz()
    gv = pyimport("graphviz")

    w = 0
    h = 0

    grid = Char[]

    open("$(homedir())/aoc-input/2023/day23/input") do io
        for l in eachline(io)
            w = length(l)
            h += 1
            append!(grid, l)
        end
    end

    grid = reshape(grid, w, h)

    nodes, edges = build_graph_dfs(grid)

    g = gv.Digraph("G")
    for ((from, to), l) in edges
        g.edge(string(from), string(to), label=string(l))
    end

    g.save()

    adj_mat = [max(get(edges, (from, to), 0), get(edges, (to, from), 0))
               for from in nodes, to in nodes]

    target = findfirst(==((w - 1, h)), nodes)

    @time dfs_max(adj_mat, target)
end

function part2()
    w = 0
    h = 0

    grid = Char[]

    open("$(homedir())/aoc-input/2023/day23/ex1") do io
        for l in eachline(io)
            w = length(l)
            h += 1
            append!(grid, l)
        end
    end

    grid = reshape(grid, w, h)

    dirs = ((1, 0), (0, 1), (-1, 0), (0, -1))
    allowed_dirs = (('>', 1), ('v', 2), ('<', 3), ('^', 4))

    function rec(path, pos)
        max_l = length(path)

        for i in 1:4
            d = dirs[i]

            np = pos .+ d

            if all(np .>= 1) && all(np .<= size(grid)) && grid[np...] != '#' &&
               np ∉ path
                push!(path, np)
                l = rec(path, np)
                delete!(path, np)

                max_l = max(max_l, l)
            end
        end

        max_l
    end

    # n3 = 0
    # n4 = 0
    # for y in 2:h-1, x in 2:w-1
    #     if grid[x, y] != '#'
    #         c = 0
    #         for d in dirs
    #             nx, ny = (x, y) .+ d
    #             if grid[nx, ny] != '#'
    #                 c += 1
    #             end
    #         end

    #         if c == 3
    #             n3 += 1
    #         elseif c == 4
    #             n4 += 1
    #         end
    #     end
    # end

    # n3, n4

    rec(Set([(2, 1)]), (2, 1)) - 1
end
