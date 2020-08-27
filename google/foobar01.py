#!/usr/bin/python 

# Module level global to track the primes
primes = set([2, 3])

# Given a value between 0 and 10 000, return the next five digits from a concatendated list of primes.
def solution(i):
    # First we need to get the relevent prime numbers, even though the list is concatendated we really
    # don't care about storing the values - we just need to make sure we start at the right offset and
    # have the next 5 (or n) values.

    # Start by getting the first prime and start of string    
    [ prime, value ] = getPrime(i)

    # Get primes until we have enough for the string
    employee = str(value)
    while len(employee) < 5:
        prime = getNextPrime(prime)
        employee += str(prime)
    
    # Return the result
    return employee[0:5]


# Get the prime number that overlaps with the index, return [ prime, value ] where value is truncated as 
# needed based upon the length
def getPrime(index):
    # Starting point is two
    prime = 2
    values = str(prime)

    # Scan until we have the starting point
    while len(values) < index:
        prime = getNextPrime(prime)        
        values += str(prime)

    # Truncate as needed
    return [ prime, values[index:] ]


# Get the next prime number given the current one.
def getNextPrime(number):
    # There's a couple ways of doing this, honestly the best would be to pre-compute the a prime lookup
    # table and then just pull the values from that...
    
    # Deal with two as a special case, since after this we can assume the number is odd
    if number == 2: return 3

    # Apply Bertrand's postulate to restrict the search space
    for value in range(number + 2, 2 * number, 2):
        if isPrime(value): return value

    raise Exception("Prime not found given input, {}".format(number))


# Check to see if the number is prime, references the module level primes variable
def isPrime(number):
    global primes
    for prime in primes:
        if number == prime: return True
        if number % prime == 0: return False
    
    # This must be a new prime, add it to the list and return
    primes.add(number)
    return True


if __name__ == "__main__":
    print 0, solution(0)
    print 3, solution(3)
    print 4, solution(4)
    print 5, solution(5)
    print 10000, solution(10000)
    