using PyCall

function find_groupsizes(wires)
    wires = deepcopy(wires)

    bidirectionalize!(wires)

    seen = Set{String}()

    ngroups = 0
    group_prod = 1

    allnames = Set(keys(wires))
    for l in values(wires), x in l
        push!(allnames, x)
    end

    for name in allnames
        if name ∉ seen
            ngroups += 1
            queue = [name]
            push!(seen, name)
            curseen = 1
            while !isempty(queue)
                newname = popfirst!(queue)
                for othername in get(wires, newname, String[])
                    if othername ∉ seen
                        push!(queue, othername)
                        push!(seen, othername)
                        curseen += 1
                    end
                end
            end

            group_prod *= curseen
        end
    end

    ngroups, group_prod
end

# Important nodes:
# smz

function bidirectionalize!(wires)
    for (from, to) in wires
        for x in to
            if haskey(wires, x)
                if from ∉ wires[x]
                    push!(wires[x], from)
                end
            else
                wires[x] = [from]
            end
        end
    end
end

function bfs_all(wires)
    wires = deepcopy(wires)
    bidirectionalize!(wires)

    allnames = collect(keys(wires))

    edge_counter = Dict{NTuple{2,String},Int}()

    function update_edges(from, to)
        k = if from < to
            (from, to)
        else
            (to, from)
        end

        edge_counter[k] = get(edge_counter, k, 0) + 1
    end

    for name in allnames
        queue = [name]
        seen = Set([name])

        while !isempty(queue)
            nname = popfirst!(queue)
            for othername in wires[nname]
                if othername ∉ seen
                    push!(seen, othername)
                    push!(queue, othername)
                    update_edges(nname, othername)
                end
            end
        end
    end

    kvps = [(v, k) for (k, v) in edge_counter]

    sort!(kvps)

    kvps[end-2:end]
end

function part1()
    wires = Dict{String,Vector{String}}()

    open("$(homedir())/aoc-input/2023/day25/input") do io
        for l in eachline(io)
            from, to = eachsplit(l, ": ")

            wires[from] = split(to)
        end
    end

    delete_these = bfs_all(wires)

    for (_, (from, to)) in delete_these
        if haskey(wires, from) && to ∈ wires[from]
            i = findfirst(==(to), wires[from])
            deleteat!(wires[from], i)
        end

        if haskey(wires, to) && from ∈ wires[to]
            i = findfirst(==(from), wires[to])
            deleteat!(wires[to], i)
        end
    end

    find_groupsizes(wires)
end

function viz_graph(wires)
    gv = pyimport("graphviz")

    g = gv.Digraph("G")

    for (from, to) in wires
        for x in to
            g.edge(from, x)
        end
    end

    g.save()
end
