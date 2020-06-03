public struct Solver {
    public init() {
    }
    
    public func solve(puzzle: Board) -> [Board] {
        return solve(startingFrom: 0, puzzle: puzzle)
    }

    private func solve(startingFrom index: Int, puzzle: Board) -> [Board] {
        precondition((0..<81).contains(index), "startingFrom index must be in range 0..<81")
        var boards = [Board]()
        var startIndex = index
        while puzzle[startIndex] != 0 {
            startIndex += 1
            guard startIndex < 81 else {
                guard puzzle.isValidSolution() else {
                    return []
                }
                return [puzzle]
            }
        }

        for number in 1...9 {
            let results = place(number: number, at: startIndex, on: puzzle)
            boards.append(contentsOf: results)
        }
        return boards
    }

    private func place(number: Int, at index: Int, on board: Board) -> [Board] {
        guard !board.getSquare(for: index).contains(number) else {
            return []
        }
        guard !board.getColumn(for: index).contains(number) else {
            return []
        }
        guard !board.getRow(for: index).contains(number) else {
            return []
        }
        var newBoard = board
        newBoard[index] = number

        if index == 80 {
            return [newBoard]
        }
        return solve(startingFrom: index + 1, puzzle: newBoard)
    }
}
