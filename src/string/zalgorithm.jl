function zalgorithm(s)
    n = length(s)
    n == 0 && return Int[]
    z = zeros(Int, n)
    z[begin] = 0
    j = 0
    for i in 1:n-1
        z[begin+i] = (j + z[begin+j] <= i) ? 0 : min(j + z[j+1] - i, z[begin+i-j])
        while i + z[begin+i] < n && s[begin+z[begin+i]] == s[begin+i+z[begin+i]] z[begin+i] += 1 end
        if j + z[begin+j] < i + z[begin+1] j = i end
    end
    z[begin] = n
    return z
end
