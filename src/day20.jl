
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
