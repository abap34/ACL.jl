struct DSU
    n
    parentorsize::Vector{Int}
    DSU(n) = n < 0 ? error("n = $n < 0: out of data") : new(n, fill(-1, n))
end

function Base.merge!(d::DSU, a, b)
    x, y = leader(d, a), leader(d, b)
    x == y && return x
    if -d.parentorsize[x] < -d.parentorsize[y]
        x,y = y,x
    end
    d.parentorsize[x] += d.parentorsize[y]
    d.parentorsize[y] = x
    return x
end

same(d::DSU, a, b) = leader(d, a) == leader(d, b)

function leader(d::DSU, a)
    d.parentorsize[a] < 0 && return a
    d.parentorsize[a] = leader(d, d.parentorsize[a])
    return d.parentorsize[a]
end

Base.size(d::DSU, a) = -d.parentorsize[leader(d, a)]

function groups(d::DSU)
    leaderbuf, groupsize = Vector{Int}(undef, d.n), zeros(Int, d.n)
    for i in 1:d.n
        leaderbuf[i] = leader(d, i)
        groupsize[leaderbuf[i]] += 1
    end
    result = map(i -> Vector{Int}(undef, 0), 1:d.n)
    for i in 1:d.n sizehint!(result[i], groupsize[leaderbuf[i]]) end
    for i in 1:d.n
        push!(result[leaderbuf[i]], i)
    end
    return filter(x -> !isempty(x), result)
end
