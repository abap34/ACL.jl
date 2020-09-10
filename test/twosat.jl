function readInput(input)
    input[2] += 1
    input[1][input[2] - 1]
end

function pushAns!(x, output)
    push!(output, string(x))
end

parseInt(x) = parse(Int, x)
parseMap(x::Array{SubString{String},1}) = map(parseInt, x)
IFL(x) = Int(floor(x))

function main(input, output)
    N,D = readInput(input) |> split |> parseMap
    ts = two_sat(N)
    p = [[0,0] for i=1:N]
    for i=1:N
        a,b = readInput(input) |> split |> parseMap
        p[i][1] = a
        p[i][2] = b
    end

    for i = 1:N
        for j = i+1:N
            for k = 0:3
                if abs(p[i][IFL(k/2) + 1] - p[j][k%2 + 1]) < D
                    add_clause!(ts, i, Bool(IFL(k/2)), j, Bool(k%2))
                end
            end
        end
    end

    if satisfiable(ts)
        println("Yes")
        for i = 1:N
            ans = answer(ts)
            pushAns!(p[i][Int(~ans[i]) + 1], output)
        end
    else
        println("No")
    end
end