function sanaive(s)
    n = length(s)
    sa = collect(1:n)
    sort!(sa,
          lt = (l,r) -> begin
              l == r && return false
              while l <= n && r <= n
                  s[l] != s[r] && return s[l] < s[r]
                  l += 1
                  r += 1
              end
              return l == n
          end)
    return sa
end

function sadoubling(s)
    n = length(s)
    sa = collect(0:n-1)
    rnk = s
    tmp = zeros(Int, n)
    k = 1
    while k < n
        cmp = (x,y) -> begin
            rnk[begin+x] != rnk[begin+y] && return rnk[begin+x] < rnk[begin+y]
            rx = x + k < n ? rnk[begin+x+k] : -1
            ry = y + k < n ? rnk[begin+y+k] : -1
            return rx < ry
        end
        sort!(sa, lt = cmp)
        tmp[begin+sa[begin]] = 0
        for i in 2:n
            tmp[begin+sa[i]] = tmp[begin+sa[i-1]] + (cmp(sa[i-1], sa[i]) ? 1 : 0)
        end
        tmp, rnk = rnk, tmp
        k *= 2
    end
    return sa .+ 1
end


function sais(s, upper; thnaive = 10, thdoubling = 40)
    n = length(s)
    n == 0 && return Int[]
    n == 1 && return [1]
    if n == 2
        s[1] < s[2] && return [1,2]
        return [2,1]
    elseif n < thnaive
        return sanaive(s)
    elseif n < thdoubling
        return sadoubling(s)
    end
    sa = zeros(Int, n)
    ls = zeros(Bool, n)
    for i in n-1:-1:1
        ls[i] = (s[i] == s[i+1]) ? ls[i+1] : (s[i] < s[i+1])
    end
    suml,sums = zeros(Int, upper+1), zeros(Int, upper+1)
    for i in 1:n
        if !ls[i] sums[s[i]] += 1
        else suml[s[i]+1] += 1
        end
    end
    for i in 1:upper+1
        sums[i] += suml[i]
        i <= upper && (suml[i+1] += sums[i])
    end

    induce! = (lms) -> begin
        fill!(sa, -1)
        buf = zeros(Int, upper+1)
        buf .= sums
        for d in lms
            d == n && continue
            sa[buf[s[d]]] = d
            buf[s[d]] += 1
        end
        buf .= suml
        for i in 1:n
            v = sa[i]
            if v >= 1 && !ls[v-1]
                sa[buf[s[v-1]]] = v - 1
                buf[s[v-1]] += 1
            end
        end
        buf .= suml
        for i in n:-1:1
            v = sa[i]
            if v >= 1 && ls[v-1]
                tmp = buf[s[v-1]+1] -= 1
                sa[tmp] = v - 1
            end
        end
    end

    lmsmap = fill(-1, n+1)
    m = 0
    for i in 2:n
        if !ls[i-1] && ls[i]
            lmsmap[i] = m
            m += 1
        end
    end
    lms = Vector{Int}(undef,0)
    sizehint!(lms, m)
    for i in 2:n
        ls[i-1] && ls[i] && (push!(lms, i))
    end

    induce!(lms)
    if m != 0
        sortedlms = Int[]
        sizehint!(sortedlms, m)
        for v in sa
            lmsmap[v] != -1 && (push!(sortedlms, v))
        end
        recs = Vector{Int}(undef, m)
        recupper = 0
        recs[lmsmap[sortedlms[1]]] = 1
        for i in 2:m
            l,r = sortedlms[i-1], sortedlms[i]
            el = (lmsmap[l] + 1 < m) ? lms[lmsmap[l] + 1] : n
            er = (lmsmap[r] + 1 < m) ? lms[lmsmap[r] + 1] : n
            same = true
            if el - l != er -r
                same = false
            else
                while l < el
                    s[l] != s[r] && break
                    l += 1
                    r += 1
                end
                (l == n || s[l] != s[r]) && (same = false)
            end
            same || (recupper += 1)
            recs[lmsmap[sortedlms[i]]] = recupper
        end

        recsa = sais(recs, recupper, thnaive=thnaive, thdoubling=thdoubling)
        for i in 1:m
            sortedlms[i] = lms[recsa[i]]
        end
        induce!(sortedlms)
    end
    return sa
end

function suffixarray(s::Array{Number}, upper)
    for d in s
        0 <= d <= upper || error("s out of scope")
    end
    sa = sais(s, upper)
    return sa
end

function suffixarray(s)
    n = length(s)
    idx = collect(1:n)
    sort!(idx, by=x->s[x])
    s2 = zeros(Int, n)
    now = 0
    for i in 1:n
        i != 1 && s[idx[i-1]] != s[idx[i]] && (now += 1)
        s2[idx[i]] = now
    end
    return sais(s2, now)
end

function lcparray(s, sa=suffixarray(s))
    n = length(s)
    rnk = zeros(Int, n)
    for i in 1:n
        rnk[sa[i]] = i
    end
    lcp = zeros(Int, n-1)
    h = 0
    for i in 1:n
        h > 0 && (h -= 1)
        rnk[i] == 1 && continue
        j = sa[rnk[i]-1]
        while j+h <= n && i+h <= n
            s[j+h] != s[i+h] && break
            h += 1
        end
        lcp[rnk[i]-1] = h
    end
    return lcp
end
