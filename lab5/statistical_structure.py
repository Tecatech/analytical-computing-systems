#!/usr/bin/python3

def get_bit(v, index):
    mask = v >> index
    mask &= 1
    return mask

sbox = {
    0: 8,
    1: 5,
    2: 14,
    3: 10,
    4: 13,
    5: 2,
    6: 6,
    7: 0,
    8: 4,
    9: 9,
    10: 3,
    11: 12,
    12: 15,
    13: 7,
    14: 11,
    15: 1
}

def compute(sbox):
    keys = list(sbox.keys())
    delta_a = []
    
    for key in keys:
        delta_i = 0
        
        for bit_idx in range(4):
            a_i = get_bit(key, bit_idx)
            x_i = get_bit(sbox[key], bit_idx)
            delta_i += a_i * x_i
        
        delta_a.append(delta_i)
    
    return delta_a

if __name__ == '__main__':
    res = compute(sbox)
    print(res)