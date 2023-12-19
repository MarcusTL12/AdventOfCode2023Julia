
function check_rule(rules, part)
    for rule in rules
        if rule isa Tuple
            var, cond, num, dest = rule

            if cond == "<" && part[var] < num ||
               cond == ">" && part[var] > num
                return dest
            end
        else
            return rule
        end
    end
end

function part1()
    workflows = Dict()

    reg1 = r"(\w+)\{(.+)\}"
    reg2 = r"(\w)(<|>)(\d+):(\w+)"

    result = 0

    open("$(homedir())/aoc-input/2023/day19/input") do io
        lines = Iterators.Stateful(eachline(io))
        for l in lines
            if isempty(l)
                break
            end

            m = match(reg1, l)

            name = m.captures[1]

            chain = []

            for part in eachsplit(m.captures[2], ',')
                m2 = match(reg2, part)
                if !isnothing(m2)
                    var, cond, num, dest = m2.captures[1:4]

                    push!(chain, (var, cond, parse(Int, num), dest))
                else
                    push!(chain, part)
                end
            end

            workflows[name] = chain
        end

        # display(workflows)

        for l in lines
            part = Dict()
            for val in eachsplit(l[2:end-1], ',')
                var, num = eachsplit(val, '=')
                part[var] = parse(Int, num)
            end

            rule = "in"
            while rule != "A" && rule != "R"
                rule = check_rule(workflows[rule], part)
            end

            if rule == "A"
                result += sum(values(part))
            end
        end
    end

    result
end

function check_rule_range(workflows, rules, part)
    output = 0
    firstrule = rules[1]
    rest = @view rules[2:end]

    if firstrule isa Tuple
        var, cond, num, dest = firstrule
        r = part[var]
        r_true = if cond == "<"
            first(r):min(last(r), num - 1)
        elseif cond == ">"
            max(first(r), num + 1):last(r)
        end
        r_false = if cond == "<"
            max(first(r), num):last(r)
        elseif cond == ">"
            first(r):min(last(r), num)
        end

        part_true = copy(part)
        part_true[var] = r_true

        part_false = copy(part)
        part_false[var] = r_false

        if !isempty(r_true)
            if dest == "A"
                output += prod(length, values(part_true))
            elseif dest != "R"
                output += check_rule_range(workflows, workflows[dest], part_true)
            end
        end

        if !isempty(r_false)
            output += check_rule_range(workflows, rest, part_false)
        end
    else
        if firstrule == "A"
            output += prod(length, values(part))
        elseif firstrule != "R"
            output += check_rule_range(workflows, workflows[firstrule], part)
        end
    end

    output
end

function part2()
    workflows = Dict()

    reg1 = r"(\w+)\{(.+)\}"
    reg2 = r"(\w)(<|>)(\d+):(\w+)"

    open("$(homedir())/aoc-input/2023/day19/input") do io
        lines = Iterators.Stateful(eachline(io))
        for l in lines
            if isempty(l)
                break
            end

            m = match(reg1, l)

            name = m.captures[1]

            chain = []

            for part in eachsplit(m.captures[2], ',')
                m2 = match(reg2, part)
                if !isnothing(m2)
                    var, cond, num, dest = m2.captures[1:4]

                    push!(chain, (var, cond, parse(Int, num), dest))
                else
                    push!(chain, part)
                end
            end

            workflows[name] = chain
        end
    end

    part = Dict(
        "x" => 1:4000,
        "m" => 1:4000,
        "a" => 1:4000,
        "s" => 1:4000,
    )

    check_rule_range(workflows, workflows["in"], part)
end
