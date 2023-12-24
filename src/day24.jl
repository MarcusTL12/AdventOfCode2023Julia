using PyCall

function part1()
    pos = BigInt[]
    vel = BigInt[]

    open("$(homedir())/aoc-input/2023/day24/input") do io
        for l in eachline(io)
            ps, vs = eachsplit(l, " @ ")
            p = big.(parse.(Int, eachsplit(ps, ", ")))
            v = big.(parse.(Int, eachsplit(vs, ", ")))

            append!(pos, p)
            append!(vel, v)
        end
    end

    pos = reshape(pos, 3, length(pos) ÷ 3)
    vel = reshape(vel, 3, length(vel) ÷ 3)

    boxmin, boxmax = big(200000000000000), big(400000000000000)
    # boxmin, boxmax = 7, 27

    result = 0

    for i in axes(pos, 2), j in 1:i-1
        # p1(t) = p1 + v1 * t
        # p2(t) = p2 + v2 * t
        # p1(t) = p2(t) => p1 + v1 * t = p2 + v2 * t
        # v1 * t - v2 * t = p2 - p1
        # (v1 - v2) * t = p2 - p1
        # t = (p2 - p1) / (v1 - v2)

        # (x, y) = (x0, y0) + (vx, vy) * t
        # x = x0 + vx * t
        # t = (x - x0) / vx
        # y = y0 + vy * t
        # y = y0 + (x - x0) * vy / vx
        # y = (vy / vx) * x - (vy / vx) * x0 + y0
        # a = vy / vx
        # b = y0 - a * x0

        # y = a1 x + b1
        # y = a2 x + b2
        # (a2 - a1) x + b2 - b1 = 0
        # x = (b1 - b2) / (a2 - a1)
        # y = a1 x + b1

        a = @. vel[2, [i, j]] // vel[1, [i, j]]
        b = @. pos[2, [i, j]] - a * pos[1, [i, j]]

        x = (b[1] - b[2]) // (a[2] - a[1])
        y = a[1] * x + b[1]

        t = @. (x - pos[1, [i, j]]) // vel[1, [i, j]]

        # @show i, j, float(x), float(y), t

        if boxmin <= x <= boxmax && boxmin <= y <= boxmax && all(t > 0 for t in t)
            # @show "hei"
            result += 1
        end
    end

    result
end

function part2()
    pos = Int[]
    vel = Int[]

    open("$(homedir())/aoc-input/2023/day24/input") do io
        for l in eachline(io)
            ps, vs = eachsplit(l, " @ ")
            p = parse.(Int, eachsplit(ps, ", "))
            v = parse.(Int, eachsplit(vs, ", "))

            append!(pos, p)
            append!(vel, v)
        end
    end

    pos = reshape(pos, 3, length(pos) ÷ 3)
    vel = reshape(vel, 3, length(vel) ÷ 3)

    # rp(t) = rp0 + rv * t
    # rp(ti) = pi(ti)
    # rp0 + rv * ti = pi0 + vi * ti

    z3 = pyimport("z3")

    rx0 = z3.Real("rx0")
    ry0 = z3.Real("ry0")
    rz0 = z3.Real("rz0")

    rp0 = [rx0, ry0, rz0]

    rvx = z3.Real("rvx")
    rvy = z3.Real("rvy")
    rvz = z3.Real("rvz")

    rv = [rvx, rvy, rvz]

    ts = [z3.Real("t$i") for i in axes(pos, 2)]

    s = z3.Solver()

    for t in ts
        s.add(t > 0)
    end

    for i in axes(pos, 2), k in 1:3
        s.add(rp0[k] + rv[k] * ts[i] == pos[k, i] + vel[k, i] * ts[i])
    end

    s.check()

    model = s.model()
    x = model.__getitem__(rx0)
    y = model.__getitem__(ry0)
    z = model.__getitem__(rz0)

    x + y + z
end
