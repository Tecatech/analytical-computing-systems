#!/usr/bin/env sage

import itertools
import random

from sage.crypto.boolean_function import BooleanFunction

BF8 = [1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 0, 1, 1, 1, 0, 0, 1, 0, 1, 1, 0, 1, 1, 0, 0, 0, 0]

Out7 = [13, 13, 10, 1, 1, 1, 7, 8, 14, 10, 3, 4, 0, 14, 10, 14, 9, 3, 14, 5, 2, 12, 9, 13, 1, 9, 2, 2, 5, 11, 9, 15, 6, 10, 5, 8, 14, 1, 9, 11, 6, 8, 3, 10, 13, 9, 2, 1, 13, 9, 6, 13, 11, 1, 0, 4, 5, 5, 2, 10, 2, 5, 15, 11, 7, 7, 11, 12, 12, 4, 0, 12, 8, 10, 3, 12, 4, 15, 15, 11, 13, 5, 9, 9, 8, 8, 10, 1, 11, 6, 3, 8, 12, 9, 5, 14, 8, 10, 15, 0, 15, 6, 10, 0, 7, 0, 10, 6, 13, 11, 0, 8, 1, 11, 3, 2, 8, 4, 0, 11, 14, 6, 0, 7, 2, 5, 14, 4, 13, 6, 14, 11, 11, 8, 8, 13, 10, 3, 12, 4, 10, 1, 15, 2, 12, 7, 9, 15, 13, 3, 0, 7, 1, 10, 11, 14, 9, 5, 5, 3, 5, 6, 12, 15, 7, 9, 7, 2, 8, 11, 13, 3, 5, 8, 15, 8, 15, 13, 0, 5, 3, 14, 3, 5, 8, 15, 6, 13, 5, 14, 5, 4, 8, 12, 15, 10, 3, 7, 0, 11, 0, 6, 12, 3, 8, 11, 2, 8, 9, 1, 11, 0, 7, 6, 8, 15, 5, 7, 9, 4, 14, 0, 2, 0, 9, 10, 0, 3, 8, 8, 1, 9, 9, 2, 10, 6, 7, 10, 2, 14, 14, 7, 8, 12, 1, 0, 15, 6, 15, 5, 0, 7, 8, 10, 15, 5, 6, 9, 13, 1, 6, 14, 9, 6, 12, 6, 3, 10, 14, 3, 12, 10, 13, 10, 10, 13, 0, 15, 11, 0, 6, 13, 2, 4, 3, 4, 5, 5, 10, 8, 9, 13, 9, 8, 8, 12, 7, 7, 3, 10, 9, 6, 14, 7, 15, 9, 8, 11, 6, 6, 0, 8, 5, 8, 3, 9, 13, 12, 4, 9, 14, 4, 4, 3, 4, 13, 8, 11, 11, 12, 14, 1, 0, 0, 7, 7, 5, 9, 12, 3, 12, 14, 7, 15, 2, 8, 15, 0, 12, 12, 4, 13, 12, 11, 15, 0, 15, 11, 6, 12, 1, 9, 8, 8, 5, 13, 8, 11, 7, 10, 0, 15, 8, 10, 6, 14, 13, 6, 7, 0, 6, 6, 2, 0, 0, 3, 1, 13, 5, 7, 6, 5, 14, 9, 0, 8, 4, 8, 0, 13, 7, 2, 6, 2, 15, 2, 1, 13, 1, 14, 13, 15, 4, 9, 1, 9, 1, 8, 6, 11, 1, 2, 10, 6, 6, 11, 6, 1, 4, 10, 7, 15, 8, 2, 10, 6, 5, 13, 7, 5, 14, 13, 5, 5, 1, 14, 4, 8, 8, 2, 3, 6, 9, 3, 7, 9, 9, 9, 10, 14, 13, 0, 6, 12, 14, 9, 15, 8, 3, 2, 0, 14, 10, 14, 8, 3, 13, 0, 1, 6, 0, 14, 4, 7, 1, 5, 12, 12, 4, 10, 12, 1, 2, 8, 15, 10, 8, 8, 9, 3, 2, 9, 15, 7, 3, 10, 1, 12, 4, 11, 8, 7, 11, 11, 4, 2, 2, 2, 15, 1, 13, 4, 6, 8, 1, 13, 5, 13, 2, 7, 12, 10, 5, 9, 3, 10, 3, 2, 4, 4, 11, 7, 3, 14, 13, 4, 11, 1, 12, 3, 3, 6, 13, 0, 7, 5, 11, 2, 4, 3, 11, 2, 13, 11, 6, 2, 0, 8, 10, 10, 5, 4, 4, 11, 15, 6, 14, 15, 7, 9, 8, 8, 1, 9, 1, 4, 7, 8, 9, 15, 15, 7, 10, 11, 3, 3, 1, 1, 4, 3, 6, 12, 7, 1, 9, 2, 11, 13, 1, 5, 14, 1, 14, 13, 4, 0, 14, 1, 4, 13, 11, 6, 1, 0, 3, 6, 6, 5, 0, 8, 1, 7, 12, 12, 0, 14, 4, 11, 12, 9, 10, 13, 13, 7, 7, 1, 1, 11, 4, 7, 8, 9, 4, 3, 14, 5, 8, 15, 3, 15, 10, 6, 0, 14, 3, 5, 7, 13, 2, 10, 10, 6, 10, 13, 9, 14, 15, 2, 14, 5, 1, 7, 10, 6, 11, 1, 15, 1, 15, 10, 0, 10, 7, 12, 6, 11, 1, 14, 13, 10, 11, 12, 10, 9, 1, 9, 15, 4, 6, 14, 1, 6, 0, 13, 8, 7, 1, 6, 5, 1, 2, 3, 6, 0, 14, 13, 1, 14, 10, 15, 2, 9, 12, 0, 4, 1, 3, 4, 0, 7, 1, 0, 3, 3, 2, 5, 4, 12, 15, 4, 5, 13, 12, 15, 1, 8, 2, 1, 14, 13, 14, 10, 0, 15, 1, 5, 14, 10, 13, 3, 10, 2, 13, 13, 2, 13, 8, 12, 7, 5, 12, 7, 9, 5, 11, 5, 5, 10, 1, 15, 6, 0, 13, 10, 4, 8, 6, 8, 10, 11, 5, 1, 3, 11, 3, 1, 1, 8, 14, 14, 7, 5, 2, 13, 12, 15, 15, 3, 1, 6, 12, 12, 1, 0, 11, 0, 7, 3, 11, 8, 9, 3, 12, 8, 8, 6, 9, 11, 1, 7, 7, 9, 12, 2, 0, 0, 14, 14, 11, 3, 8, 7, 9, 12, 15, 14, 5, 1, 14, 1, 9, 8, 9, 11, 9, 7, 14, 1, 15, 6, 13, 8, 3, 3, 1, 0, 11, 11, 1, 6, 15, 4, 1, 15, 1, 4, 13, 13, 10, 12, 14, 0, 12, 12, 4, 0, 0, 6, 3, 10, 10, 14, 12, 11, 13, 2, 1, 0, 9, 0, 1, 10, 14, 4, 12, 5, 14, 4, 3, 10, 3, 13, 11, 14, 9, 2, 3, 2, 3, 0, 13, 6, 2, 5, 4, 12, 13, 6, 12, 2, 9, 4, 15, 15, 0, 5, 4, 12, 11, 10, 14, 11, 13, 10, 10, 10, 3, 12, 9, 1, 0, 4, 6, 13, 2, 6, 15, 3, 3, 3, 5, 13, 10, 0, 13, 9, 13, 3, 15, 0, 6, 4, 1, 13, 5, 13, 0, 7, 10, 0, 2, 12, 1, 12, 8, 14, 2, 11, 9, 8, 9, 5, 8, 2, 5, 1, 15, 5, 1, 1, 2, 6, 5, 3, 14, 14, 7, 4, 3, 8, 9, 7, 0, 15]

def decimal(vec):
    return sum(val * (2 ** idx) for idx, val in enumerate(reversed(vec)))

def group(arr, off):
    vec = [arr[idx : idx + off] for idx in range(0, len(arr), off)]
    return [decimal(val) for val in vec]

def combined(BF, Out):
    F = GF(2)
    o = F(0)
    l = F(1)
    
    coef = [
        [l, o, o, o, o, o, o, o, o, l, o, l],
        [l, o, o, o, o, o, o, l, o, l, l, l],
        [l, o, o, o, o, o, l, o, l, o, l, l],
        [l, o, o, o, o, o, l, o, l, l, o, l],
        [l, o, o, o, o, l, o, o, o, l, l, l],
        [l, o, o, o, o, l, l, o, o, o, l, l]
    ]
    
    tr = list(itertools.product([o, l], repeat = 12))
    fill = []
    
    while True:
        arr = []
        
        for _ in range(len(tr)):
            fill = random.sample(tr, len(coef))
            reg = list(map(lambda val: sum(lfsr_sequence(val[0], list(val[1]), 12)), list(zip(coef, fill))))
            B = BooleanFunction(BF)
            arr.append(int(B[reg]))
        
        if group(arr, 4) == Out:
            break
    
    return fill

if __name__ == '__main__':
    file = open('lab3.txt', 'w')
    sys.stdout = file
    
    init = combined(BF8, Out7)
    print(init)