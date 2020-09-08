function floorsum(n, m, a, b)
    ans = 0
    if a >= m
        ans += (n-1) * n * (a÷m) ÷ 2
        a %= m
    end
    if b >= m
        ans += n * (b÷m);
        b %= m
    end

    ymax = (a * n + b) ÷ m
    xmax = (ymax * m - b)
    ymax == 0 && return ans
    ans += (n - (xmax + a - 1) ÷a ) * ymax
    ans += floorsum(ymax, a, m, (a - xmax % a) % a)
    return ans
end
