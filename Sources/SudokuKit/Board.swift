import Foundation

public struct Board {
    private var board: [Int]
    private let boardWidth = 9
    private let boardRange = 0..<81
    private let squareWidth = 3

    public func getSquare(for index: Int) -> [Int] {
        precondition((0..<81).contains(index), "Index must be in range 0..<81")
        let squareInRow = index % boardWidth / 3
        let topLeftIndex = squareInRow * 3 + (index / 27) * 27
        let offsets = [0, 1, 2, 9, 10, 11, 18, 19, 20]
        var elements = Array<Int>.init(repeating: 0, count: 9)
        for (index, offset) in offsets.enumerated() {
            elements[index] = board[topLeftIndex + offset]
        }
        return elements
    }

    public func getRow(for index: Int) -> [Int] {
        precondition((0..<81).contains(index), "Index must be in range 0..<81")
        var elements = Array<Int>.init(repeating: 0, count: 9)
        let row = index / boardWidth
        let startIndex = row * boardWidth
        for index in 0..<9 {
            elements[index] = board[startIndex + index]
        }
        return elements
    }

    public func getColumn(for index: Int) -> [Int] {
        precondition((0..<81).contains(index), "Index must be in range 0..<81")
        let startIndex = index % boardWidth
        var elements = Array<Int>.init(repeating: 0, count: boardWidth)
        for offset in 0..<9 {
            elements[offset] = board[startIndex + offset * boardWidth]
        }
        return elements
    }

    public subscript(index: Int) -> Int {
        get {
            board[index]
        }
        set(newValue) {
            precondition((0..<81).contains(index), "Index must be in range 0..<81")
            board[index] = newValue
        }
    }

    public init(board: [Int]) {
        precondition(board.count == 81, "Board must have exactly 81 elements.")
        self.board = board
    }

    public func isValidSolution() -> Bool {
        let numbers = Set([1, 2, 3, 4, 5, 6, 7, 8, 9])
        for index in stride(from: 0, through: 80, by: 9) {
            let row = Set(getRow(for: index))
            if numbers != row {
                return false
            }
        }
        for index in 0..<9 {
            let column = Set(getColumn(for: index))
            if numbers != column {
                return false
            }
        }
        for index in [0, 3, 6, 27, 30, 33, 54, 57, 60] {
            let square = Set(getSquare(for: index))
            if numbers != square {
                return false
            }
        }
        return true
    }

    public init?() {
        guard let board = Board.resolve(board: Board.fill(), from: 0) else {
            return nil
        }
        self.board = board
    }

    static private func resolve(board: [Int], from position: Int) -> [Int]? {
        guard position < board.count else {
            return board
        }
        var result: [Int]?
        let seen = collectSeenNumbers(for: position, on: board)
        if seen.contains(board[position]) {
            result = swapNumber(at: position, on: board, excluding: seen)
        } else {
            result = resolve(board: board, from: position + 1)
            if result != nil {
                return result
            } else {
                result = swapNumber(at: position, on: board, excluding: seen)
            }
        }
        return result
    }

    static private func collectSeenNumbers(for position: Int, on board: [Int]) -> Set<Int> {
        var seen = Set<Int>()
        // Row
        let rowStart = (position / 9) * 9
        for index in rowStart..<position {
            precondition(index < position, "Index must be smaller than the current position")
            seen.insert(board[index])
        }
        // Column
        for index in stride(from: position % 9, to: position, by: 9) {
            precondition(index < position, "Index must be smaller than the current position")
            seen.insert(board[index])
        }
        return seen
    }

    static private func swapNumber(at position: Int, on board: [Int], excluding seen: Set<Int>) -> [Int]? {
        var searchPos = position
        var result: [Int]?
        repeat {
            if searchPos % 3 == 2 {
                searchPos += 7
            } else {
                searchPos += 1
            }
            guard searchPos < board.count && Board.inSameSquare(position, searchPos) else {
                return nil
            }
            if !seen.contains(board[searchPos]) {
                var newBoard = board
                newBoard.swapAt(position, searchPos)
                result = resolve(board: newBoard, from: position + 1)
                if let result = result {
                    return result
                }
            }
        } while result == nil
        return nil
    }

    static private func inSameSquare(_ first: Int, _ second: Int) -> Bool {
        let column1 = first % 9 / 3
        let row1 = first / 27
        let column2 = second % 9 / 3
        let row2 = second / 27
        return column1 == column2 && row1 == row2
    }

    private static func fill() -> [Int] {
        var numbers = Array(stride(from: 1, through: 9, by: 1))
        var board = Array(repeating: 0, count: 81)
        for index in 0..<81 {
            if index % 9 == 0 {
                numbers.shuffle()
            }
            let indexInBox = ((index / 3) % 3) * 9 + ((index % 27) / 9) * 3 + (index / 27) * 27 + (index % 3);
            board[indexInBox] = numbers[index % 9]
        }
        return board
    }
}

extension Board: CustomStringConvertible {
    public var description: String {
        var workingCopy = ""
        for index in 0..<81 {
            workingCopy += " \(board[index] )"
            if index % 9 == 2 || index % 9 == 5 {
                workingCopy += "|"
            }
            if index % 9 == 8 {
                workingCopy += "\n"
            }
            if index % 27 == 26 && index != 80  {
                workingCopy += "------+------+------\n"
            }
        }
        return workingCopy
    }
}
