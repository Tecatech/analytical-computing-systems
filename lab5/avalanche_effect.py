#!/usr/bin/python3

def bit_flip(x):
    mask = x + 1
    mask &= 1
    return mask

def get_bit(v, index):
    mask = v >> index
    mask &= 1
    return mask

def set_bit(v, index, x):
    mask = 1 << index
    v &= ~mask
    
    if x:
        v |= mask
    
    return v

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
    prob = []
    
    for func_idx in range(4):
        num = 0
        
        for key in keys:
            out_bit = get_bit(sbox[key], func_idx)
            
            for bit_idx in range(4):
                x = get_bit(key, bit_idx)
                new_key = set_bit(key, bit_idx, bit_flip(x))
                new_bit = get_bit(sbox[new_key], func_idx)
                
                if new_bit != out_bit:
                    num += 1
        
        prob.append(num)
    
    return prob

if __name__ == '__main__':
    res = compute(sbox)
    print(res)