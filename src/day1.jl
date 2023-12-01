
function part1()
    # inp = open(String ∘ read, "$(homedir())/aoc-input/2023/day1/input")

    x = 0

    open("$(homedir())/aoc-input/2023/day1/input") do io
        for l in eachline(io)
            y = 0

            i = 0
            d1 = 0
            d2 = 0

            for c in l
                if isdigit(c)
                    i += 1
                    if i == 1
                        d1 = c - '0'
                    end
                    d2 = c - '0'
                end
            end

            y = 10d1 + d2

            x += y
        end
    end

    x
end

function part2()
    reg = r"\d|one|two|three|four|five|six|seven|eight|nine"

    d = Dict([
        "1" => 1,
        "2" => 2,
        "3" => 3,
        "4" => 4,
        "5" => 5,
        "6" => 6,
        "7" => 7,
        "8" => 8,
        "9" => 9,
        "one" => 1,
        "two" => 2,
        "three" => 3,
        "four" => 4,
        "five" => 5,
        "six" => 6,
        "seven" => 7,
        "eight" => 8,
        "nine" => 9,
        ])

    x = 0

    open("$(homedir())/aoc-input/2023/day1/input") do io
        for l in eachline(io)
            y = 0

            i = 0
            d1 = 0
            d2 = 0

            for m in eachmatch(reg, l, overlap=true)
                dg = d[m.match]
                i += 1
                if i == 1
                    d1 = dg
                end
                d2 = dg
            end

            y = 10d1 + d2

            x += y
        end
    end

    x
end
