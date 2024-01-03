import random
import time


def Karatsuba(x, y):
	if len(str(x))==1 or len(str(y))==1:
		return x*y
	if x<=10 or y<=10:
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

def barrett_reduction(dividend, modulus, divisor, mu):
    k = modulus.bit_length() // 2
    l=Karatsuba((k - 1), 64)
    q1 = dividend >> l#((k - 1) * 64)
    r1 = dividend % (2 ** l)
    
    q2 = (q1 * mu) >> Karatsuba((k + 1), 64)#((k + 1) * 64)
    r2 = dividend - Karatsuba(q2, divisor)#q2 * divisor
    
    while r2 >= modulus:
        r2 -= modulus
        
    return r2

if __name__ == "__main__":
    num_bits = 2048
    num = random.getrandbits(num_bits)
    modulus = random.getrandbits(num_bits)
    divisor = 2 ** 2048
    mu = (2 ** (2 * (modulus.bit_length() // 2))) // divisor
    
    start_time = time.time()
    a = barrett_reduction(num, modulus, divisor, mu)
    end_time = time.time()
    print(f"Barrett reduction: {a}")
    
    start_time_mod = time.time()
    b = num % modulus
    end_time_mod = time.time()
    print(f"Modulus operator:  {b}")
    
    time_barrett = end_time - start_time
    time_modulus = end_time_mod - start_time_mod
    
    if a == b:
        print("Results are the same")
    else:
        print("Results are different")
        
    #print(f"Computation time of Barrett reduction: {time_barrett:.6f} seconds")
    #print(f"Computation time of modulus operator:  {time_modulus:.6f} seconds")
