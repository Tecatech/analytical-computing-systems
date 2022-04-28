#!/usr/bin/env sage

from enum import IntEnum
from math import ceil, gcd, sqrt
import random

class Methods(IntEnum):
    Fermat = 0,
    PollardRho = 1

def modular_pow(base, exponent, modulus):
    result = 1
    
    while exponent > 0:
        if exponent & 1:
            result = (result * base) % modulus
        
        exponent = exponent >> 1
        base = (base * base) % modulus
    
    return result

def FermatFactor(n):
    if n <= 1:
        return [n]
    
    if n & 1 == 0:
        return [n / 2, 2]
    
    u = ceil(sqrt(n))
    
    if u * u == n:
        return [u, u]
    
    while True:
        v1 = u * u - n
        v = int(sqrt(v1))
        
        if v * v == v1:
            break
        else:
            u += 1
    
    return [u, v, u - v, u + v]

def PollardRhoFactor(n):
    if n <= 1:
        return [n]
    
    if n & 1 == 0:
        return [n / 2, 2]
    
    x = random.randint(0, 2) % (n - 2)
    y = x
    
    c = random.randint(0, 1) % (n - 1)
    d = 1
    
    i = 0
    
    while d == 1:
        x = (modular_pow(x, 2, n) + c + n) % n
        
        y = (modular_pow(y, 2, n) + c + n) % n
        y = (modular_pow(y, 2, n) + c + n) % n
        
        d = gcd(abs(x - y), n)
        
        i += 1
        
        if d == n:
            return PollardRhoFactor(n)
    
    return [n / d, d, i]

if __name__ == '__main__':
    n07 = [240321262400599, 21458463990809]
    n14 = [240316413836573, 23006648575597]
    
    file = open('lab4.txt', 'w')
    sys.stdout = file
    
    res07_1 = FermatFactor(n07[Methods.Fermat])
    print('res07_1 =', res07_1)
    res14_1 = FermatFactor(n14[Methods.Fermat])
    print('res14_1 =', res14_1)
    
    res07_2 = PollardRhoFactor(n07[Methods.PollardRho])
    print('res07_2 =', res07_2)
    res14_2 = PollardRhoFactor(n14[Methods.PollardRho])
    print('res14_2 =', res14_2)