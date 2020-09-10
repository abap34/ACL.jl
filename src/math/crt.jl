function invgcd(a,b)
    a = mod1(a,b)
    a == 0 && return (b, 0)
    s,t = b,a
    m0,m1 = 0,1
    while t != 0
        u = s ÷ t
        s -= t * u
        m0 -= m1 * u

        tmp = s
        s = t
        t = tmp
        tmp = m0
        m0 = m1
        m1 = tmp
    end
    if m0 < 0
        m0 += b÷s
    end
    return (s, m0)
end

function crt(r, m)
    r0, m1 = 0, 1
    for i in 1:length(r)
        r1,m1 = mod1(r[i], m[i]), m[i]
        if m0 < m1
            m0,m1 = m1,m0
            r0,r1 = r1,r0
        end
        if m0 % m1 == 0
            r0 % m1 != r1 && return (0,0)
            continue
        end
        g, invm = invgcd(m0,m1)

        u1 = m1 ÷ g
        (r1-r0) % g && return (0, 0)
        x = (r1-r0) ÷ g % u1 * invm % u1
        r0 += x * m0
        m0 *= u1
        if r0 < 0 
            r0 += m0
        end
    end
    return (r0, m0)
end
