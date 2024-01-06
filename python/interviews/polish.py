#!/usr/bin/env python3

def solve(expression: str) -> int:
    stack = []

    # Reverse the inputs and parse them
    for symbol in expression[::-1].split():
        # Push numbers on the stack
        if symbol not in '+-*/':
            stack.append(int(symbol))
            continue

        # Get the left and right of the expression
        left = stack.pop()
        right = stack.pop()

        # Parse the operations
        if symbol == '+':
            stack.append(add(left, right))
        elif symbol == '-':
            stack.append(subtract(left, right))
        elif symbol == '*':
            stack.append(multiplication(left, right))
        elif symbol == '/':
            stack.append(division(left, right))
        else:
            raise Exception('Unknown operand, {}'.format(symbol))
        
    # Return the result
    return stack.pop()

def add(left, right):
    return left + right

def subtract(left, right):
    return left - right

def multiplication(left, right):
    return left * right

def division(left, right):
    # Check for divide by zero
    if right == 0: raise Exception('Divide by zero!')

    # Return an integer from the division
    return int(left / right)


if __name__ == '__main__':
    print(solve('+ 3 4'))
    print(solve('- 3 * 4 5'))
    print(solve('* + 3 4 5'))
    print(solve('/ -  3 4 + 5 2'))