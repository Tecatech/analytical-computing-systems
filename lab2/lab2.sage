#!/usr/bin/env sage
import sys
from sage.crypto.boolean_function import BooleanFunction
import toyplot

A18 = [
    [0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    [0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0],
    [1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 1, 1, 0, 0, 1, 1, 1, 0],
    [0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0],
    [1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0],
    [1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 1, 1, 0],
    [1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1],
    [0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1],
    [0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 1],
    [1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0],
    [0, 1, 0, 1, 1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 1, 1, 1],
    [1, 1, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0, 1],
    [1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1, 1, 1],
    [0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1],
    [1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0],
    [0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1],
    [1, 0, 1, 0, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1],
    [0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1]
]

B18 = [0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1]

class FiniteStateMachine:
    def __init__(self):
        self.F = GF(2)
        self.A = A18
        self.B = B18
    
    
    def transitions(self):
        A = automata.Word(self.A)
        return A.transitions()
    
    
    def lfsr_sequence(self):
        key = list(self.F(s) for s in self.B)
        L = list()
        
        for row in self.A:
            fill = list(self.F(s) for s in row)
            L.append(lfsr_sequence(key, fill, len(row)))
        
        s = automata.Word(L)
        return s.transitions()
    
    
    def charpoly(self):
        A = matrix(BooleanPolynomialRing(len(self.B)), self.A)
        return A.charpoly()


class DeBruijnFunctions:
    def __init__(self, k, n, c = None):
        self.k = k
        self.n = n
        self.B = self.__debruijn_functions(k, n, c)
    
    
    def __debruijn_functions(self, k, n, c):
        D = DeBruijnSequences(k, n)
        
        if c == None:
            c = D.cardinality()
        
        seq = D.an_element()
        s = list()
        
        for i in range(c):
            seq.insert(0, seq.pop())
            s.append(seq.copy())
        
        return list(BooleanFunction(seq) for seq in sorted(s))
    
    
    def __debruijn_words(self, seq):
        shift = lambda i: [(i + j) % self.k ** self.n for j in range(self.n)]
        words = list()
        
        for i in range(self.k ** self.n):
            words.append(''.join([str(b) for j, b in enumerate(seq) if j in shift(i)]))
        
        return words
    
    
    def __debruijn_graph(self, seq):
        words = self.__debruijn_words(seq)
        edges = set()
        
        for w1 in words:
            for w2 in words:
                if w1 != w2:
                    if w1[1:] == w2[:-1]:
                        edges.add((w1[:-1], w2[:-1]))
                    if w1[:-1] == w2[1:]:
                        edges.add((w2[:-1], w1[:-1]))
        
        return edges
    
    
    def __debruijn_graph_plot(self, edges, width = 500, height = 500):
        graph = toyplot.graph(
            [i[0] for i in edges],
            [i[1] for i in edges],
            width = width,
            height = height,
            tmarker = '>',
            vsize = 25,
            vstyle = {'stroke': 'black', 'stroke-width': 2, 'fill': 'none'},
            vlstyle = {'font-size': '11px'},
            estyle = {'stroke': 'black', 'stroke-width': 2},
            layout = toyplot.layout.FruchtermanReingold(edges = toyplot.layout.CurvedEdges()))
        
        return graph
    
    
    def debruijn_graphs(self):
        g = list()
        
        for b in self.B:
            g.append(self.__debruijn_graph(b.truth_table(format = 'int')))
        
        return g
    
    
    def truth_tables(self):
        tr = list()
        
        for b in self.B:
            tr.append(b.truth_table())
        
        return tr
    
    
    def algebraic_normal_forms(self):
        P = list()
        
        for b in self.B:
            pbpoly = b.algebraic_normal_form()
            P.append((pbpoly, len(pbpoly)))
        
        return P
    
    
    def walsh_hadamard_transform(self):
        W = list()
        
        for b in self.B:
            W.append(b.walsh_hadamard_transform())
        
        return W


if __name__ == '__main__':
    file = open('lab2.txt', 'w')
    sys.stdout = file
    
    FSM = FiniteStateMachine()
    
    print('PROBLEM #1')
    print('Transitions:', *FSM.transitions(), sep = '\n')
    print('LFSR sequence:', *FSM.lfsr_sequence(), sep = '\n')
    print('Characteristic polynomial:', FSM.charpoly())
    print()
    
    D1 = DeBruijnFunctions(2, 4)
    
    print('PROBLEM #2')
    print('Truth tables:', *D1.truth_tables(), sep = '\n')
    print('Algebraic normal forms:', *D1.algebraic_normal_forms(), sep = '\n')
    print('Walsh-Hadamard coefficients:', *D1.walsh_hadamard_transform(), sep = '\n')
    print('De Bruijn graphs:', *D1.debruijn_graphs(), sep = '\n')
    print()
    
    D2 = DeBruijnFunctions(2, 10, 5)
    
    print('PROBLEM #3')
    print('Truth tables:', *D2.truth_tables(), sep = '\n')
    print('Algebraic normal forms:', *D2.algebraic_normal_forms(), sep = '\n')
    print('Walsh-Hadamard coefficients:', *D2.walsh_hadamard_transform(), sep = '\n')