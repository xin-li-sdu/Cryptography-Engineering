from math import gcd
import random
import sys

def Karatsuba(x, y):
	if len(str(x))==1 or len(str(y))==1:
		return x*y
	
	n = max(len(str(x)), len(str(y)))
	k = n//2
	x1 = x // 10**k
	x0 = x % 10**k
	y1 = x // 10**k
	y0 = x % 10**k
	z0 = Karatsuba(x0, y0)
	z2 = Karatsuba(x1, y1)
	z1 = Karatsuba((x1+x0), (y1+y0)) - z2 - z0
	xy = z2*10**(k*2) + z1*10**(k) + z0

	return xy
    
def ext_gcd(a, b, arr):
    """扩欧"""
    if b == 0:
        arr[0] = 1
        arr[1] = 0
        return a
    g = ext_gcd(b, a % b, arr)
    t = arr[0]
    arr[0] = arr[1]
    arr[1] = t - int(a / b) * arr[1]
    return g


def inv(a, n):
    """求逆"""
    arr = [0, 1, ]
    gcd = ext_gcd(a, n, arr)
    if gcd == 1:
        return (arr[0] % n + n) % n
    else:
        return -1


def find_R(N):
    """R >= 2^k > N"""
    N_origin = N
    k = 0
    while N >= 1:
        k += 1
        N = N >> 1
    R = 2 ** k
    while 1:
        if gcd(N_origin, R) == 1:
            break
        else:
            R += 1
    return R


def Mon_reduction(X, R, N):
    N_pie = R - inv(N, R)
    m = X * N_pie % R
    y = int((X + m * N) // R)
    if y > N:
        y -= N
    return y


def Mon_MultMon(a, b, N):
    R = find_R(N)
    a_hat = a * R % N
    b_hat = b * R % N
    X = a_hat * b_hat
    X_1 = Mon_reduction(X, R, N)
    y = Mon_reduction(X_1, R, N)
    return y

def Mon_Mod(a, b, N):
    R = find_R(N)
    a_hat = a * R % N  # a -> Montgomery
    ans_hat = R % N    # initialize ans = 1 -> Montgomery
    
    while b != 0:
        if b & 1:
            ans_hat = Mon_reduction(ans_hat * a_hat, R, N)  # ans = ans * a % N
            #ans_hat = Mon_reduction(Karatsuba(ans_hat, a_hat), R, N)  # ans = ans * a % N
        b = b >> 1
        a_hat = Mon_reduction(a_hat * a_hat, R, N)  # a = a * a % N
    ans = Mon_reduction(ans_hat, R, N)
    return ans

print("----------reduction-----------")
sys.setrecursionlimit(8000)
num_bits = 2048
a = random.getrandbits(num_bits)
b = random.getrandbits(num_bits)
n = random.getrandbits(num_bits)
ans3 = a * inv(b, n) % n
print("Simple result:", ans3)

ans4 = Mon_reduction(a, b, n)

print("Mon reduction:", ans4)
print("Success" if ans3 == ans4 else "Fail")



print("------------Mod-------------")
a = random.getrandbits(num_bits)
b = random.getrandbits(num_bits)
n = random.getrandbits(num_bits)
ans1 = a * b % n
ans2 = Mon_MultMon(a, b, n)
print("Simple result:", ans1)
print("Mon MultiMod :", ans2)
print("Success" if ans1 == ans2 else "Fail")




print("------------Power Mod-------------")
a = random.getrandbits(32)
b = random.getrandbits(16)
n = random.getrandbits(1024)
ans5 = a ** b % n
ans6 = Mon_Mod(a, b, n)
print("Simple result:", ans5)
print("Mon MultiMod :", ans6)
print("Success" if ans5 == ans6 else "Fail")

