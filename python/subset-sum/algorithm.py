#!/usr/bin/env python3

# algorithm.py
#
# Alternative approach to to the classic Sub-Set Sum problem, time and space 
# complexity appear to be about O(2^(n / 3)) for an exact solution using
# recursion. Without recursion it should be possible to use linearly bounded
# space - maybe O(2n)?
#
# Matrix-based memoization techniques actually hurt the performance over just
# checking the same location again.
import math
import random


class subset:
  calls = 0     # Analytics
  ops = 0       # Analytics

  def prepare(self, set, target):
    if sum(set) < target: return False, [], self.calls, self.ops        # 1. Return false if the sum of the set is less than the target
    set.sort(reverse = True)                                            # 2. Sort the set, largest to smallest
    results, values = self.solve(set, target)                           # 3. Call the solver to begin recursion
    return results, values, self.calls, self.ops

  def solve(self, set, target):
    results = []                                                        # 4. Prepare our working space
    for ndx in range(len(set)):                                         # 5. Scan for the next valid value

      self.ops += 1       # Analytics

      if set[ndx] > target: continue                                    # 5.1 If the value is greater, continue
      results.append(set[ndx])                                          # 5.2 Append the current value to the results
      if (target - set[ndx]) == 0: return True, results                 # 5.3 Return true if the sum is zero
      if (ndx + 1) == len(set): return False, []                        # 5.4 If we are at the end of the set, then the answer must be False

      self.calls += 1     # Analytics

      result, temp = self.solve(set[(ndx + 1):], (target - set[ndx]))   # 5.5 Otherwise, check the working value against the smaller
      if result == True: return True, (results + temp)                  # 5.6 If the result was true, pass it along
      results.pop()                                                     # 5.7 The last value was not a match, remove it
    return False, []                                                    # 6. Loop exited, not a subset


def driver(set, target):
  result, values, calls, ops = subset().prepare(set, target)

  # Calculate the density, Howgrave-Graham & Joux (2010)
  density = len(set) / math.log2(max(set))

  with open('results.csv', 'a') as out:
    out.write('{},{},{:.4f},{}\n'.format(ops, calls, density, result))

  if result: print(target, values, sum(values))

  print('Ops: {}, Calls: {}, Density: {:.4f}'.format(ops, calls, density))

def generate(size, bound):
  set = []
  for ndx in range(size):
    set.append(random.randint(0, bound))
  return set, random.randint(0, bound)

def known_sets():
  driver([6, 1, 2, 1], 4)                         # True
  driver([1, 7, 2, 9, 10], 6)                     # False
  driver([3, 0, 4, 9, 5], 17)                     # True
  driver([2, 2, 2, 3, 2, 2], 10)                  # True
  driver([3, 34, 4, 12, 3, 2], 7)                 # True
  driver([3, 34, 4, 12, 5, 2], 9)                 # True
  driver([3, 34, 4, 12, 5, 2], 30)                # False
  driver([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 100)    # False  

if __name__ == '__main__':
  for ndx in range(1000):
    set, target = generate(96, 1e32)
    driver(set, target)

  # known_sets()