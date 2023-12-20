import graphviz as gv

g = gv.Digraph("G", "test.gv")

with open("C:\\Users\\marcu\\aoc-input\\2023\\day20\\input") as f:
    for l in f:
        i, o = l.strip().split(" -> ")
        if i.startswith('%') or i.startswith('&'):
            ix = i[1:]
        else:
            ix = i
        g.node(ix, label=i)
        for ox in o.split(", "):
            g.edge(ix, ox)

g.save()
