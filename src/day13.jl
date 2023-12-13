
Base.adjoint(c::Char) = c

function has_mirror_plane_at(mat, mirror_plane)
    has_plane = true
    i = mirror_plane
    j = mirror_plane + 1
    while i >= 1 && j <= size(mat, 2)
        if (@view mat[:, i]) != (@view mat[:, j])
            has_plane = false
            break
        end

        i -= 1
        j += 1
    end

    has_plane
end

function has_vertical_mirror(mat)
    for i in 1:size(mat, 2)-1
        if has_mirror_plane_at(mat, i)
            return i
        end
    end

    0
end

function part1()
    inp = open(String ∘ read, "$(homedir())/aoc-input/2023/day13/input")

    x = 0

    for block in eachsplit(inp, "\n\n")
        m = 0
        n = 0

        mat = Char[]

        for l in eachsplit(block, '\n')
            if !isempty(l)
                n += 1
                m = length(l)
                append!(mat, l)
            end
        end

        mat = reshape(mat, m, n)

        a = has_vertical_mirror(mat)
        b = has_vertical_mirror(mat')

        if a == 0
            x += b
        else
            x += 100a
        end
    end

    x
end

function has_vertical_mirror_nothere(mat, j)
    for i in 1:size(mat, 2)-1
        if i != j && has_mirror_plane_at(mat, i)
            return i
        end
    end

    0
end

function look_for_smudge(mat)
    a = has_vertical_mirror(mat)
    b = has_vertical_mirror(mat')

    for i in eachindex(mat)
        if mat[i] == '.'
            mat[i] = '#'
        else
            mat[i] = '.'
        end

        x = has_vertical_mirror_nothere(mat, a)
        y = has_vertical_mirror_nothere(mat', b)

        if x != a && x != 0
            return (x, 0)
        elseif y != b && y != 0
            return (0, y)
        end

        if mat[i] == '.'
            mat[i] = '#'
        else
            mat[i] = '.'
        end
    end
end

function part2()
    inp = open(String ∘ read, "$(homedir())/aoc-input/2023/day13/input")

    x = 0

    for block in eachsplit(inp, "\n\n")
        m = 0
        n = 0

        mat = Char[]

        for l in eachsplit(block, '\n')
            if !isempty(l)
                n += 1
                m = length(l)
                append!(mat, l)
            end
        end

        mat = reshape(mat, m, n)

        a, b = look_for_smudge(mat)

        if a == 0
            x += b
        else
            x += 100a
        end
    end

    x
end
