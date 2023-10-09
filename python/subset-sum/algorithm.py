#!/usr/bin/env python3

# algorithm.py
#
# Alternative approach to to the classic Sub-Set Sum problem
import math
import random


class subset:
  calls = 0     # Analytics
  ops = 0       # Analytics

  def prepare(self, set, target):
    # Return false if the sum of the set is less than the target
    if sum(set) < target: return False, self.calls, self.ops

    # Sort the set, largest to smallest
    set.sort(reverse = True)

    # Call the solver and return the its solution along with the analytics
    return self.solve(set, target), self.calls, self.ops

  def solve(self, set, target):
    working = target                                    # 1. Copy the working value
    for ndx in range(len(set)):                         # 2. Scan for the next valid value

      self.ops += 1     # Analytics
      
      if set[ndx] <= working:                           # 2.1 Examine a possible set value
        working -= set[ndx]                             # 2.1.1 Apply the change
        if working == 0: return True                    # 2.1.2 Return true if the sum is zero
        if (ndx + 1) == len(set): return False          # 2.1.3 If we are at the end of the set, then the answer must be False

        self.calls += 1     # Analytics

        result = self.solve(set[(ndx + 1):], working)   # 2.1.4 Otherwise, check the working value against the smaller
        if result == True: return True                  # 2.1.5 If the result was true, pass it along
        working += set[ndx]                             # 2.1.6 Otherwise, reverse the value

    return False                                        # 3. Loop exited, not a subset


def driver(set, target):
  result, calls, ops = subset().prepare(set, target)

  # Calculate the density, Howgrave-Graham & Joux (2010)
  density = len(set) / math.log2(max(set))

  with open('results.csv', 'a') as out:
    out.write('{},{},{:.4f},{}\n'.format(ops, calls, density, result))

  # print(set, target, result)
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
    set, target = generate(16, 1e4)
    driver(set, target)
