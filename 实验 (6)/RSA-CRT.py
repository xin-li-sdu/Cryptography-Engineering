# coding=utf-8
from math import gcd
import random

# 求模反元素
def mod_inverse(a, m):
    def egcd(a, b):
        if b == 0:
            return (a, 1, 0)
        else:
            (d, x, y) = egcd(b, a % b)
            return (d, y, x - (a // b) * y)

    d, x, y = egcd(a, m)
    if d != 1:
        return None
    else:
        return x % m

# 生成质数
def generate_prime(bit_length):
    while True:
        p = random.getrandbits(bit_length)
        if p % 2 != 0 and pow(2, p-1, p) == 1:
            #print("find prime")
            return p

# 生成公钥和私钥
def generate_keypair(bit_length):
    p = generate_prime(bit_length // 2)
    q = generate_prime(bit_length // 2)
    #print(2)
    n = p * q
    phi_n = (p - 1) * (q - 1)
    e = 65537  # 选取一个较大的素数作为公共指数e
    d = mod_inverse(e, phi_n)
    #print(1)
    dp = d % (p - 1)
    dq = d % (q - 1)
    qinv = mod_inverse(q, p)
   # print("generate_keypair")
    return (n, e), (n, d, p, q, dp, dq, qinv)

# RSA加密
def rsa_encrypt(m, public_key):
    n, e = public_key
    #c = pow(m, e, n)
    c=Montgomery_ladder(m, e, n)
    return c

# RSA解密
def rsa_decrypt(c, private_key):
    n, d, p, q, dp, dq, qinv = private_key
    #m1 = pow(c, dp, p)
    m1=Montgomery_ladder(c, dp, p)
    #m2 = pow(c, dq, q)
    m2=Montgomery_ladder(c, dq, q)
    h = (qinv * (m1 - m2)) % p
    m = m2 + h * q
    return m


def Montgomery_ladder(x,n,p):#蒙哥马利阶梯算法
    # 将y转换为二进制表示形式
    l = bin(n)[2:]
   
    # 初始化变量
    t1 = x
    t2 = x*x
    for i in range(1,len(l)):
        if l[i] == '0':
            # 如果当前位为0，执行加法步骤
            t2 = (t1 * t2) %p
            t1 = (t1 * t1)%p
        elif l[i] == '1':
            # 如果当前位为1，执行乘法步骤
            t1= (t1 * t2) %p
            t2= (t2 * t2) %p 
    return t1


# 生成公私钥对
public_key, private_key = generate_keypair(512)

# 明文
m = 12345

# 加密
c = rsa_encrypt(m, public_key)
print("c:", c)

# 解密
m_decrypt = rsa_decrypt(c, private_key)
print("p:", m_decrypt)

