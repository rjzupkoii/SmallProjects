#!/usr/bin/python 

def solution(l, t):
    for ndx in range(0, len(l)):
        offset =sum(l[ndx:], ndx, t)
        if offset != -1: return [ ndx, offset + ndx ]
    
    return [ -1, -1 ]

    
def sum(values, start, target):
    total = 0
    for ndx in range(0, len(values)):
        total += values[ndx]
        if total == target: return ndx
    return -1


if __name__ == "__main__":
    print solution([1, 2, 3, 4], 15)
    print solution([4, 3, 10, 2, 8], 12)