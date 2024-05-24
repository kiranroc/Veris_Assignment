def find_battleship(board):
    rows = len(board)
    cols = len(board[0])
    
    # Check for horizontal battleship
    for r in range(rows):
        for c in range(cols - 2):
            if board[r][c] == 1 and board[r][c + 1] == 1 and board[r][c + 2] == 1:
                return [[r, c], [r, c + 1], [r, c + 2]]
    
    # Check for vertical battleship
    for r in range(rows - 2):
        for c in range(cols):
            if board[r][c] == 1 and board[r + 1][c] == 1 and board[r + 2][c] == 1:
                return [[r, c], [r + 1, c], [r + 2, c]]
    
    return []

# Example usage:
board1 = [
    [0, 0, 0, 0, 0],
    [1, 0, 0, 0, 0],
    [1, 0, 0, 0, 0],
    [1, 0, 0, 0, 0],
    [0, 0, 0, 0, 0]
]

board2 = [
    [0, 0, 0, 0, 0],
    [0, 1, 1, 1, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0]
]

print(find_battleship(board1))  # Output: [[1,0],[2,0],[3,0]]
print(find_battleship(board2))  # Output: [[1,1],[1,2],[1,3]]
