#!/usr/bin/env sage
from functools import reduce
from itertools import product
from sage.crypto.boolean_function import BooleanFunction
from sage.crypto.sbox import SBox
from sage.rings.integer import Integer

S7 = (
     54,  50,  62,  56,  22,  34, 94,  96,  38,   6, 63,  93,   2,  18, 123, 33,
     55, 113,  39, 114,  21,  67, 65,  12,  47,  73, 46,  27,  25, 111, 124, 81,
     53,   9, 121,  79,  52,  60, 58,  48, 101, 127, 40, 120, 104,  70,  71, 43,
     20, 122,  72,  61,  23, 109, 13, 100,  77,   1, 16,   7,  82,  10, 105, 98,
    117, 116,  76,  11,  89, 106,  0, 125, 118,  99, 86,  69,  30,  57, 126, 87,
    112,  51,  17,   5,  95,  14, 90,  84,  91,   8, 35, 103,  32,  97,  28, 66,
    102,  31,  26,  45,  75,   4, 85,  92,  37,  74, 80,  49,  68,  29, 115, 44,
     64, 107, 108,  24, 110,  83, 36,  78,  42,  19, 15,  41,  88, 119,  59,  3,
)

S9 = (
    167, 239, 161, 379, 391, 334,   9, 338,  38, 226,  48, 358, 452, 385,  90, 397,
    183, 253, 147, 331, 415, 340,  51, 362, 306, 500, 262,  82, 216, 159, 356, 177,
    175, 241, 489,  37, 206,  17,   0, 333,  44, 254, 378,  58, 143, 220,  81, 400,
     95,   3, 315, 245,  54, 235, 218, 405, 472, 264, 172, 494, 371, 290, 399,  76,
    165, 197, 395, 121, 257, 480, 423, 212, 240,  28, 462, 176, 406, 507, 288, 223,
    501, 407, 249, 265,  89, 186, 221, 428, 164,  74, 440, 196, 458, 421, 350, 163,
    232, 158, 134, 354,  13, 250, 491, 142, 191,  69, 193, 425, 152, 227, 366, 135,
    344, 300, 276, 242, 437, 320, 113, 278,  11, 243,  87, 317,  36,  93, 496,  27,
    487, 446, 482,  41,  68, 156, 457, 131, 326, 403, 339,  20,  39, 115, 442, 124,
    475, 384, 508,  53, 112, 170, 479, 151, 126, 169,  73, 268, 279, 321, 168, 364,
    363, 292,  46, 499, 393, 327, 324,  24, 456, 267, 157, 460, 488, 426, 309, 229,
    439, 506, 208, 271, 349, 401, 434, 236,  16, 209, 359,  52,  56, 120, 199, 277,
    465, 416, 252, 287, 246,   6,  83, 305, 420, 345, 153, 502,  65,  61, 244, 282,
    173, 222, 418,  67, 386, 368, 261, 101, 476, 291, 195, 430,  49,  79, 166, 330,
    280, 383, 373, 128, 382, 408, 155, 495, 367, 388, 274, 107, 459, 417,  62, 454,
    132, 225, 203, 316, 234,  14, 301,  91, 503, 286, 424, 211, 347, 307, 140, 374,
     35, 103, 125, 427,  19, 214, 453, 146, 498, 314, 444, 230, 256, 329, 198, 285,
     50, 116,  78, 410,  10, 205, 510, 171, 231,  45, 139, 467,  29,  86, 505,  32,
     72,  26, 342, 150, 313, 490, 431, 238, 411, 325, 149, 473,  40, 119, 174, 355,
    185, 233, 389,  71, 448, 273, 372,  55, 110, 178, 322,  12, 469, 392, 369, 190,
      1, 109, 375, 137, 181,  88,  75, 308, 260, 484,  98, 272, 370, 275, 412, 111,
    336, 318,   4, 504, 492, 259, 304,  77, 337, 435,  21, 357, 303, 332, 483,  18,
     47,  85,  25, 497, 474, 289, 100, 269, 296, 478, 270, 106,  31, 104, 433,  84,
    414, 486, 394,  96,  99, 154, 511, 148, 413, 361, 409, 255, 162, 215, 302, 201,
    266, 351, 343, 144, 441, 365, 108, 298, 251,  34, 182, 509, 138, 210, 335, 133,
    311, 352, 328, 141, 396, 346, 123, 319, 450, 281, 429, 228, 443, 481,  92, 404,
    485, 422, 248, 297,  23, 213, 130, 466,  22, 217, 283,  70, 294, 360, 419, 127,
    312, 377,   7, 468, 194,   2, 117, 295, 463, 258, 224, 447, 247, 187,  80, 398,
    284, 353, 105, 390, 299, 471, 470, 184,  57, 200, 348,  63, 204, 188,  33, 451,
     97,  30, 310, 219,  94, 160, 129, 493,  64, 179, 263, 102, 189, 207, 114, 402,
    438, 477, 387, 122, 192,  42, 381,   5, 145, 118, 180, 449, 293, 323, 136, 380,
     43,  66,  60, 455, 341, 445, 202, 432,   8, 237,  15, 376, 436, 464,  59, 461,
)

class Kasumi:
    def __init__(self):
        self.field = [0, 1]
        self.S7 = S7
        self.S9 = S9
    
    
    # https://github.com/sagemath/sagelib/blob/master/sage/crypto/boolean_function.pyx#L47
    def __hamming_weight_int(self, x):
        x -=  (x >> 1) & 0x55555555L
        x  = ((x >> 2) & 0x33333333L) + (x & 0x33333333L)
        x  = ((x >> 4) + x) & 0x0f0f0f0fL
        x *= 0x01010101L
        return x >> 24
    
    
    def hamming_weight_int(self, input):
        sbox = SBox(input)
        
        hamming_weight_int_list = list()
        
        for x in range(2 ** sbox.m):
            hamming_weight_int_list.append(self.__hamming_weight_int(x))
        
        return hamming_weight_int_list
    
    
    # https://github.com/sagemath/sagelib/blob/master/sage/coding/linear_code.py#L213
    def __hamming_weight(self, input):
        return len(input.nonzero_positions())
    
    
    def hamming_weight(self, input):
        sbox = SBox(input)
        
        hamming_weight_list = list()
        
        for x in range(sbox.m):
            boolean_function = sbox.component_function(1 << x)
            hamming_weight_list.append(self.__hamming_weight(vector(boolean_function.truth_table())))
        
        return hamming_weight_list
    
    
    def zhegalkin_polynomial(self, input):
        sbox = SBox(input)
        
        hamming_weight_list = list()
        
        for x in range(sbox.m):
            boolean_function = sbox.component_function(1 << x)
            truth_table_list = list(map(int, list(boolean_function.truth_table())))
            
            for i in range(1, sbox.m + 1):
                for s in range(2 ** (sbox.m - i)):
                    for l in range(2 ** (i - 1)):
                        truth_table_list[2 ** i * s + 2 ** (i - 1) + l] = truth_table_list[2 ** i * s + l] ^^ truth_table_list[2 ** i * s + 2 ** (i - 1) + l]
            
            hamming_weight_list.append(truth_table_list.count(1))
        
        return hamming_weight_list
    
    
    def zhegalkin_polynomial_linear_span(self, input):
        sbox = SBox(input)
        
        linear_span_list = list(combination for combination in product(self.field, repeat = 2 ** sbox.m))
        hamming_weight_list = list()
        
        for x in range(sbox.m):
            boolean_function = sbox.component_function(1 << x)
            
            combination_weight_list = list()
            truth_table_list = list()
            
            for combination in linear_span_list:
                for linear_span_element, truth_table_element in zip(combination, boolean_function.truth_table()):
                    truth_table_list.append(linear_span_element * truth_table_element)
                
                for i in range(1, sbox.m + 1):
                    for s in range(2 ** (sbox.m - i)):
                        for l in range(2 ** (i - 1)):
                            truth_table_list[2 ** i * s + 2 ** (i - 1) + l] = truth_table_list[2 ** i * s + l] ^^ truth_table_list[2 ** i * s + 2 ** (i - 1) + l]
                
                combination_weight_list.append(truth_table_list.count(1))
            
            hamming_weight_list.append(combination_weight_list)
        
        return hamming_weight_list
    
    
    def zhegalkin_polynomial_set(self, input):
        return sum(self.zhegalkin_polynomial(input))
    
    
    def fourier_walsh_hadamard(self, input):
        sbox = SBox(input)
        
        fourier_walsh_hadamard_list = list()
        
        for x in range(sbox.m):
            boolean_function = sbox.component_function(1 << x)
            fourier_walsh_hadamard_list.append(boolean_function.walsh_hadamard_transform())
        
        return fourier_walsh_hadamard_list
    
    
    def __linear_analog(self, input):
        linear_analog_list = list('x' + str(index) for index, digit in enumerate(input) if digit != '0')
        
        for i in range(len(linear_analog_list) - 1):
            linear_analog_list.insert(2 * i + 1, ' + ')
        
        return ''.join(linear_analog_list)
    
    
    def affine_approximation(self, input):
        sbox = SBox(input)
        
        affine_approximation_list = list()
        
        for x in range(sbox.m):
            boolean_function = sbox.component_function(1 << x)
            normalized_fourier_list = list(coefficient / (2 ** sbox.m) for coefficient in boolean_function.walsh_hadamard_transform())
            nonzero_indices_list = list(Integer(index).binary().zfill(sbox.m) for index, coefficient in enumerate(normalized_fourier_list) if coefficient != 0)
            
            function_approximation_list = list()
            
            for index in nonzero_indices_list:
                function_approximation_list.append(self.__linear_analog(index))
            
            affine_approximation_list.append(function_approximation_list)
        
        return affine_approximation_list
    
    
    def match_probability(self, input):
        sbox = SBox(input)
        
        match_probability_list = list()
        
        for x in range(sbox.m):
            boolean_function = sbox.component_function(1 << x)
            normalized_fourier_list = list(coefficient / (2 ** sbox.m) for coefficient in boolean_function.walsh_hadamard_transform())
            match_probability_list.append((max(map(abs, normalized_fourier_list)) + 1) / 2)
        
        return match_probability_list


if __name__ == '__main__':
    kasumi = Kasumi()
    
    print('Fourier coefficient list:', kasumi.fourier_walsh_hadamard(S7))
    print('Linear analog list:', kasumi.affine_approximation(S9))