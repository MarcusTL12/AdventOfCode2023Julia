
function pushbutton(modules, state)
    pulsequeue = [("button" => "broadcaster", false)]

    n_low = 0
    n_high = 0

    while !isempty(pulsequeue)
        (from, name), pulse = popfirst!(pulsequeue)

        if pulse
            n_high += 1
        else
            n_low += 1
        end

        if haskey(modules, name)
            pref, outputs = modules[name]

            if name == "broadcaster"
                for dest in outputs
                    push!(pulsequeue, ((name => dest), pulse))
                end
            elseif pref == '%' && !pulse
                nextpulse = !state[name]
                state[name] = nextpulse
                for dest in outputs
                    push!(pulsequeue, ((name => dest), nextpulse))
                end
            elseif pref == '&'
                inpstate = state[name]
                inpstate[from] = pulse
                nextpulse = !all(values(inpstate))
                for dest in outputs
                    push!(pulsequeue, ((name => dest), nextpulse))
                end
            end
        end
    end

    n_low, n_high
end

function part1()
    modules = Dict()

    open("$(homedir())/aoc-input/2023/day20/input") do io
        for l in eachline(io)
            name, outputs = eachsplit(l, " -> ")
            pref, name = if startswith(name, '&') || startswith(name, '%')
                name[1], name[2:end]
            else
                ' ', name
            end

            modules[name] = (pref, split(outputs, ", "))
        end
    end

    state = Dict(k => if pref == '&'
        Dict()
    else
        false
    end for (k, (pref, _)) in modules)

    for (name, (_, outputs)) in modules
        for outname in outputs
            if haskey(modules, outname) && modules[outname][1] == '&'
                state[outname][name] = false
            end
        end
    end

    n_low, n_high = 0, 0

    for _ in 1:1000
        n_low, n_high = (n_low, n_high) .+ pushbutton(modules, state)
    end

    n_low * n_high
end

function part2()
    modules = Dict()

    open("$(homedir())/aoc-input/2023/day20/input") do io
        for l in eachline(io)
            name, outputs = eachsplit(l, " -> ")
            pref, name = if startswith(name, '&') || startswith(name, '%')
                name[1], name[2:end]
            else
                ' ', name
            end

            modules[name] = (pref, split(outputs, ", "))
        end
    end

    state = Dict(k => if pref == '&'
        Dict()
    else
        false
    end for (k, (pref, _)) in modules)

    for (name, (_, outputs)) in modules
        for outname in outputs
            if haskey(modules, outname) && modules[outname][1] == '&'
                state[outname][name] = false
            end
        end
    end

    rx_inp = ""

    for (k, (_, outputs)) in modules
        if "rx" ∈ outputs
            rx_inp = k
            break
        end
    end

    state_seeds = modules["broadcaster"][2]

    state_names_list = [
        begin
            seed_queue = [s]
            state_names = String[]
            while !isempty(seed_queue)
                k = pop!(seed_queue)
                for ns in modules[k][2]
                    if ns != rx_inp && ns ∉ state_names
                        push!(seed_queue, ns)
                        push!(state_names, ns)
                    end
                end
            end

            sort!(state_names)
        end for s in state_seeds
    ]

    function get_state(state_names)
        [
            if state[n] isa Dict
                sort!(collect(state[n]))
            else
                state[n]
            end for n in state_names
        ]
    end

    seen_states = [Dict(get_state(sn) => 0) for sn in state_names_list]

    cycles = [(-1, -1) for _ in seen_states]

    for i in Iterators.countfrom(1)
        pushbutton(modules, state)

        for (j, state_names) in enumerate(state_names_list)
            st = get_state(state_names)
            if haskey(seen_states[j], st)
                if cycles[j] == (-1, -1)
                    cycles[j] = (seen_states[j][st], i)
                end
            else
                seen_states[j][st] = i
            end
        end

        if all(!=((-1, -1),), cycles)
            break
        end
    end

    lcm(((b - a) for (a, b) in cycles)...)
end
