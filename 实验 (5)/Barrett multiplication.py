import random
def barrett_mod_mul(a, b, n, mu):
    # 计算模数位数的一半
    k = (n.bit_length() + 1) // 2
    q1 = (a >> (k - 1) * 64)# 将 a 和 b 进行巴雷特约简预处理
    r1 = a % (1 << (k - 1) * 64)
    q2 = (b >> (k - 1) * 64)
    r2 = b % (1 << (k - 1) * 64)
    t = q1 * q2     # 计算 t = q1 * q2 (mod n)
    t1 = t % (1 << (k + 1) * 64)
    m = q1 * r2 + q2 * r1# 计算 m = q1 * r2 + q2 * r1 (mod n)
    m = m % (1 << (k + 1) * 64)
    # 计算 t = t + m * mu (mod n)
    t = (t1 + m * mu) % (1 << (k + 1) * 64)
    # 计算 r = a * b (mod n)
    r = (r1 * r2 - t * n) % n
    if r < 0:
        r += n
    return r

def test_barrett_mod_mul():
    num_bits = 2048
    a = random.getrandbits(num_bits)
    b = random.getrandbits(num_bits)
    n = random.getrandbits(num_bits)
    
    k = (n.bit_length() + 1) // 2
    
    mu = (1 << (k + 1) * 64) // n
    
    result = barrett_mod_mul(a, b, n, mu) 
    
    expected = (a * b) % n

    print(result)
    print(expected)
    
    assert result == expected, f"Test case failed: {a} * {b} (mod {n}) = {result}, expected {expected}"
    print("test cases passed.")
    
test_barrett_mod_mul()
