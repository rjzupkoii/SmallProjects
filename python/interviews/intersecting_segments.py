#!/usr/bin/env python3

# Find the maximum number of non-intersecting pairs of integers with the same sum.
#
# This can be done in linear time O(n), the big trick is to make sure that you are
# resetting the tracking of the previous value since four values in a row should 
# give you two groups.
import collections

def solution(A):
    counts = collections.defaultdict(int)
    previous = -1

    for ndx in range(len(A) - (len(A) % 2)):
        # Get the sum for this group
        total = sum(A[ndx:(ndx + 2)])

        # If the total is the same as the previous group, reset the previous value
        # since the next entry will be the start of a new chain
        if total == previous:
            previous = -1
            continue
        
        # Update the count and the tracking of the previous value
        counts[total] += 1
        previous = total        

    return max(counts.values())


if __name__ == '__main__':
    # Sample input, expected solution
    print(solution([10, 1, 3, 1, 2, 2, 1, 0, 4]), 3)    # [(3, 1); (2, 2); (0, 4)] or [(1, 3), (2, 2), (0, 4)]
    print(solution([5, 3, 1, 3, 2, 3]), 1)              # Any singular group note that (3, 1) and (1, 3) are the same and chained
    print(solution([9, 9, 9, 9, 9]), 2)                 # [(9, 9); (9, 9)]
    print(solution([9, 9, 9, 9, 9, 9]), 3)              # [(9, 9); (9, 9); (9, 9)]
    print(solution([1, 5, 2, 4, 3, 3]), 3)              # [(1, 5); (2, 4); (3, 3)]
    print(solution([0, 0, 0, 1, 2, 0, 0]), 2)           # [(0, 0); (0, 0)]
