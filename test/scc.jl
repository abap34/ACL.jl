function readInput(input)
    input[2] += 1
    input[1][input[2] - 1]
end

function pushAns!(x, output)
    push!(output, x)
end

parseInt(x) = parse(Int, x)
parseMap(x::Array{SubString{String},1}) = map(parseInt, x)
parseVertex(x) = string(x-1)

function main(input, output)
    N,M = readInput(input) |> split |> parseMap
    sg = scc_graph(N)
    for i = 1:M
        a,b = readInput(input) |> split |> parseMap
        add_edge!(sg, a+1, b+1)
    end

    groups = scc(sg)
    println(length(groups))
    for group in groups
        l = length(group)
        pushAns!(string(l) * " " * join(map(parseVertex, group)," "), output)
    end
end
