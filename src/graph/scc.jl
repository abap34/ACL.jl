struct csr{E}
    start::Array{Int}
    elist::Array{E}

    function csr{E}(n::Int, edges::Array{Pair{Int, E}}) where E
        start = zeros(Int, n + 1)
        elist = Array{E}(undef, length(edges))
                
        for e in edges
            start[e[1] + 1] += 1
        end
        
        for i = 2:n+1
            start[i] += start[i - 1]
        end

        counter::Array{Int} = copy(start)
        for e in edges
            elist[counter[e[1]] + 1] = e[2] 
            counter[e[1]] += 1
        end

        new{E}(start, elist)
    end
end

struct edge
    to::Int
end

mutable struct scc_graph
    n::Int
    edges::Array{Pair{Int, edge}}

    scc_graph(n::Int) = new(n, Array{Pair{Int, edge},1}())
end

num_vertices(sg::scc_graph)::Int = sg.n

function add_edge!(sg::scc_graph, from::Int, to::Int)
    new_edge = Pair{Int, edge}(from, edge(to))
    push!(sg.edges, new_edge)
end

function dfs_for_scc!(v::Int, g::csr{edge}, ord_group::Array{Int},
    visited::Array{Int}, low::Array{Int}, ord::Array{Int},
    ids::Array{Int}, sg::scc_graph)
    low[v] = ord_group[1]
    ord[v] = ord_group[1]
    ord_group[1] += 1
    push!(visited, v)
    for i = g.start[v] + 1:g.start[v + 1]
        to = g.elist[i].to
        if ord[to] == -1
            dfs_for_scc!(to, g, ord_group, visited, low, ord, ids, sg)
            low[v] = min(low[v], low[to])
        else
            low[v] = min(low[v], ord[to])
        end
    end

    if low[v] == ord[v]
        while true
            u = pop!(visited)
            ord[u] = sg.n
            ids[u] = ord_group[2]
            if u == v
                break
            end
        end
        ord_group[2] += 1
    end
end

function scc_ids(sg::scc_graph)::Pair{Int, Array{Int}}
    g = csr{edge}(sg.n, sg.edges)
    ord_group = [1, 0] 
    visited = Array{Int,1}()
    low = zeros(Int, sg.n)
    ord = [-1 for i = 1:sg.n]
    ids = zeros(Int, sg.n)

    for i = 1:sg.n
        if ord[i] == -1
            dfs_for_scc!(i, g, ord_group, visited, low, ord, ids, sg)
        end
    end

    for i = 1:sg.n
        ids[i] = ord_group[2] - ids[i]
    end

    Pair{Int, Array{Int}}(ord_group[2], ids)
end

function scc(sg::scc_graph)
    ids = scc_ids(sg)
    group_num = ids[1]
    counts = zeros(Int, group_num)
    for x in ids[2]
        counts[x] += 1
    end
    groups = [Array{Int, 1}() for i = 1:group_num]
    for i = 1:sg.n
        push!(groups[ids[2][i]], i)
    end

    groups
end

#=
# ACL practice contestでvalidation済

parseInt(x) = parse(Int, x)
parseMap(x::Array{SubString{String},1}) = map(parseInt, x)
parseVertex(x) = string(x-1)

function main()
    N,M = readline() |> split |> parseMap
    sg = scc_graph(N)
    for i = 1:M
        a,b = readline() |> split |> parseMap
        add_edge!(sg, a+1, b+1)
    end

    groups = scc(sg)
    println(length(groups))
    for group in groups
        l = length(group)
        println(string(l) * " " * join(map(parseVertex, group)," "))
    end
end

main()
=#