function zalgorithm(s)
    n = length(s)
    n == 0 && return Int[]
    z = Vector{Int}(undef, n)
    z[1] = 0
    j = 0
    for i in 2:n
        k = (j + z[j] <= i) ? 0 : min(j + z[j] - i, z[i - j])
        while i + k < n && s[k] == s[i+k] k += 1 end
        if j + z[j] < i + z[i]
            j = i
        end
    end
    z[1] = n
    return z
end
