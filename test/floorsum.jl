#=
https://judge.yosupo.jp/problem/sum_of_floor_of_linear
を利用したjudge
=#

function readInput(input)
    input[2] += 1
    input[1][input[2] - 1]
end

function pushAns!(x, output)
    push!(output, string(x))
end

parseInt(x) = parse(Int, x)
parseMap(x::Array{SubString{String},1}) = map(parseInt, x)

function main(input, output)
    T = readInput(input) |> parseInt
    for i = 1:T
        N, M, A, B = readInput(input) |> split |> parseMap
        pushAns!(floorsum(N, M, A, B), output)       
    end
end