#!/usr/bin/python 

class Node:
    def __init__(self, value):
        self.left = None
        self.right = None
        self.value = value


def solution(h, q):
    [root, value] = buildTree(h, Node(h), 0)
    results = []
    for index in q:
        results.append(getParent(root, index))
    return results


def buildTree(h, node, value):
    # Have we reached the bottom?
    if h == 1:
        value += 1
        node.value = value
        return [node, value]

    # We are still building
    [node.left, value] = buildTree(h - 1, Node(-1), value)
    [node.right, value] = buildTree(h - 1, Node(-1), value)
    value += 1
    node.value = value
    return [node, value]


def getParent(node, index):
    # Are we at the bottom?
    if node.left is None: return -1
    if node.right is None: return -1

    # Peek to see if found our target
    if node.left.value == index: return node.value
    if node.right.value == index: return node.value

    result = getParent(node.left, index)
    if result != -1: return result
    return getParent(node.right, index)


def printTree(root):
    if root.left is not None: printTree(root.left)
    if root.right is not None: printTree(root.right)
    print root.value
    

if __name__ == "__main__":
    print solution(3, [7, 3, 5, 1])
    print solution(5, [19, 14, 28])