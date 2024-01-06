#!/usr/bin/env python3

def solve(incoming: str) -> str:
    # Prase the matrix, check to see if it's valid
    matrix = parse(incoming)
    if validate(matrix):
        return 'OK'
    
    # If it's not valid, then attempt a single bit flip
    return test(matrix)

def parse(text: str):
    # Determine how big the matrix is
    lines = text.split('\n')
    size = int(lines[0])

    # Allocate a matrix
    matrix = [[0 for col in range(size)] for row in range(size)]

    # Copy the data to the matrix adn return
    row = 0
    for line in lines[1::]:
        col = 0
        for entry in line.split():
            matrix[row][col] = int(entry)
            col += 1
        row += 1
    return matrix

def test(matrix: int):
    # Attempt to bit flip each entry in the matrix
    for row in range(len(matrix)):
        for col in range(len(matrix)):
            # Perform the bit flip, make sure we restore the data when we are done
            original = matrix[row][col]
            matrix[row][col] = 1 if original == 0 else 0
            result = validate(matrix)
            matrix[row][col] = original

            # Return the success message
            if result: 
                return 'Change bit ({},{})'.format(row + 1, col + 1)
            
    # Looks like it would take more than one bit flip
    return 'Corrupt'

def validate(matrix: int):
    # Validate by row, return false if any fail
    for line in matrix:
        if sum(line) % 2:
            return False

    # Validate by column, return false if any fail
    for col in range(len(matrix)):
        total = 0
        for row in range(len(matrix)):
            total += matrix[row][col]
        if total % 2:
            return False

    # Return success
    return True    


if __name__ == '__main__':
    # OK
    print(solve("""4
1 0 1 0
0 0 0 0
1 1 1 1
0 1 0 1"""))
    
    # Change bit (2,3)
    print(solve("""4
1 0 1 0
0 0 1 0
1 1 1 1
0 1 0 1"""))
    
    # Corrupt
    print(solve("""4
1 0 1 0
0 1 1 0
1 1 1 1
0 1 0 1"""))
