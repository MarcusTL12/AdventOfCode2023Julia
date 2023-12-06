
function get_num_ways(t, d)
    n = 0
    for ta in 0:t
        t_cruise = t - ta
        d_cruise = ta * t_cruise
        if d_cruise > d
            n += 1
        end
    end
    n
end

function part1()
    ts = [59     68     82     74]
    ds = [543   1020   1664   1022]

    prod(get_num_ways(t, d) for (t, d) in zip(ts, ds))
end

function part2()
    get_num_ways(59688274, 543102016641022)
end
