# 将来共通処理をinternal_scc.jlに移す予定
include("scc.jl")

mutable struct two_sat
    n::Int
    answer::Array{Bool}
    sg::scc_graph

    two_sat() = new(0, Array{Bool, 1}(), scc_graph(0))
    two_sat(n) = new(n, [false for i = 1:n], scc_graph(2 * n))
end

function add_clause!(ts::two_sat, i::Int, f::Bool, j::Int, g::Bool)
    add_edge!(ts.sg, 2 * i + (f ? 0 : 1) - 1, 2 * j + (g ? 1 : 0) - 1)
    add_edge!(ts.sg, 2 * j + (g ? 0 : 1) - 1, 2 * i + (f ? 1 : 0) - 1) 
end

function satisfiable(ts::two_sat)::Bool
    id = scc_ids(ts.sg)[2]
    for i = 1:ts.n
        if id[2 * i - 1] == id[2 * i]
            return false
        end
        ts.answer[i] = id[2 * i - 1] < id[2 * i]
    end
    true
end

answer(ts::two_sat) = ts.answer

#=
# ACL practice contestでvalidation済

parseInt(x) = parse(Int, x)
parseMap(x::Array{SubString{String},1}) = map(parseInt, x)
IFL(x) = Int(floor(x))

function main()
    N,D = readline() |> split |> parseMap
    ts = two_sat(N)
    p = [[0,0] for i=1:N]
    for i=1:N
        a,b = readline() |> split |> parseMap
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
            println(p[i][Int(~ans[i]) + 1])
        end
    else
        println("No")
    end
end

main()
=#