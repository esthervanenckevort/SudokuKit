// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// Board.swift provides the Sudoku board with initializers to create a board
// from a preexisting array or generate a new board.

import Foundation

/// Sudoku board implementation.
public struct Board {
    public private(set) var board: [Int]
    /// The valid values of the Sudoku, for a typical 9x9 Sudoku this will be 1...9
    public var numbers: ClosedRange<Int> { 1...columns }
    /// The width of the Sudoku board, for a typical 9x9 Sudoku this will be 9
    public var columns: Int { Int(sqrt(Double(board.count))) }
    /// The height of the Sudoku board, for a typical 9x9 Sudoku this will be 9
    public var rows: Int { columns }
    /// The width of a single Square, for the typical 9x9 Sudoku this will be 3
    public var widthOfSquare: Int { Int(sqrt(Double(columns))) }
    /// The height of a single Square, for the typical 9x9 Sudoku this will be 3
    public var heightOfSquare: Int { widthOfSquare }
    /// The number of squares in a row, for the typical 9x9 Sudoku this will be 3
    public var squaresInRow: Int { widthOfSquare }
    /// The nukber of squares in a column, for the typical 9x9 Sudoku this will be 3
    public var squaresInColumn: Int { widthOfSquare }
    /// The offset of a row of squares, for the typical 9x9 Sudoku this will be 9*3 = 27
    public var squareRowOffset: Int { columns * widthOfSquare }

    public enum Level: String {
        case easy, simple, expert, intermediate

        public func boards() -> [Board] {
            guard let file = Bundle.module.url(forResource: "games/\(self.rawValue)", withExtension: "txt") else { fatalError("Can't locate resource games/\(self.rawValue).txt in Bundle SudokuKit") }
            guard let puzzles = try? String(contentsOf: file) else { fatalError("Can't load file for difficulty level \(self.rawValue)")}
            var boards = [Board]()
            for puzzle in puzzles.split(separator: "\n") {
                let board = puzzle.replacingOccurrences(of: ".", with: "0").compactMap { Int(String($0)) }
                boards.append(Board(board: board))
            }
            return boards
        }
    }

    public static func load(level: Level) -> [Board] {
        return level.boards()
    }

    public static func randomBoard(for level: Level) -> Board {
        return level.boards().randomElement()!
    }

    /// Initialize a board with the given array.
    ///
    /// - Parameter board: an array containing an existing board with the numbers 0 - 9, where 0
    ///                    indicates an empty field.
    public init(board: [Int]) {
        self.board = board
        let count = columns * columns
        let possibleValues = 0...columns

        precondition(board.count == count, "Board must have exactly \(count) elements.")
        precondition(board.reduce(true) { possibleValues.contains($1) }, "Board must only contain elements in the range 0...\(columns)")

    }

    /// Get the numbers in the square for the given position.
    /// - Parameter index: The position in the range 0...80 for which to retreive the square.
    /// - Returns: An array with the nine values in rowwise order
    public func getSquare(for index: Int) -> [Int] {
        precondition((0..<board.count).contains(index), "Index must be in range \(0..<board.count)")
        let squareInRow = index % columns / widthOfSquare
        let topLeftIndex = squareInRow * widthOfSquare + (index / squareRowOffset) * squareRowOffset
        var offsets = [Int]()
        for row in 0..<heightOfSquare {
            for column in 0..<widthOfSquare {
                offsets.append(column + row * columns)
            }
        }
        var elements = Array<Int>.init(repeating: 0, count: columns)
        for (index, offset) in offsets.enumerated() {
            elements[index] = board[topLeftIndex + offset]
        }
        return elements
    }


    /// Get the numbers in the row for the given position.
    /// - Parameter index: The position in the range 0...80 for which to retreive the row.
    /// - Returns: An array with the nine values from left to right.
    public func getRow(for index: Int) -> [Int] {
        precondition((0..<board.count).contains(index), "Index must be in range 0..<\(board.count)")
        var elements = Array<Int>.init(repeating: 0, count: columns)
        let row = index / columns
        let startIndex = row * columns
        for index in 0..<columns {
            elements[index] = board[startIndex + index]
        }
        return elements
    }

    /// Get the numbers in the column for the given position.
    /// - Parameter index: The position in the range 0...80 for which to retreive the column
    /// - Returns: An array with the nine values from top to bottom.
    public func getColumn(for index: Int) -> [Int] {
        precondition((0..<board.count).contains(index), "Index must be in range 0..<\(board.count)")
        let startIndex = index % columns
        var elements = Array<Int>.init(repeating: 0, count: columns)
        for offset in 0..<columns {
            elements[offset] = board[startIndex + offset * columns]
        }
        return elements
    }

    /// Direct access to the board
    public subscript(index: Int) -> Int {
        get {
            precondition((0..<board.count).contains(index), "Index must be in range 0..<\(board.count)")
            return board[index]
        }
        set(newValue) {
            precondition((0..<board.count).contains(index), "Index must be in range 0..<\(board.count)")
            precondition((0...columns).contains(newValue), "The new value must be in the range 0...\(columns)")
            board[index] = newValue
        }
    }

    /// Check if this board is a valid solution.
    /// - Returns: true if the board is a valid solution, which means all fields are filled with a number in
    ///            the range 1...9 and each row and each column contains each of the numbers only
    ///            once.
    public func isValidSolution() -> Bool {
        let numbers = Set(self.numbers)
        for index in stride(from: 0, to: board.count, by: columns) {
            let row = Set(getRow(for: index))
            if numbers != row {
                return false
            }
        }
        for index in 0..<columns {
            let column = Set(getColumn(for: index))
            if numbers != column {
                return false
            }
        }
        for row in 0..<squaresInColumn {
            for index in stride(from: 0, to: columns, by: widthOfSquare) {
                let square = Set(getSquare(for: index + row * squareRowOffset))
                if numbers != square {
                    return false
                }
            }
        }
        return true
    }
}

extension Board: CustomStringConvertible {

    /// Description of the board. A 9 x 9 square divided in 9 3 x 3 squares with the numbers 0...9 printed.
    public var description: String {
        var workingCopy = ""
        for index in 0..<board.count {
            workingCopy += " \(board[index])"
            switch index {
            case board.count - 1:
                break
            case (let x) where x % columns == columns - 1:
                workingCopy += "\n"
                if x % squareRowOffset == squareRowOffset - 1 {
                    for square in 0..<widthOfSquare {
                        workingCopy += String(Array(repeating: "-", count: widthOfSquare * 2))
                        if square == widthOfSquare - 1 {
                            workingCopy += "\n"
                        } else {
                            workingCopy += "+"
                        }
                    }
                }
            case (let x) where x % widthOfSquare == widthOfSquare - 1:
                workingCopy += "|"
            default:
                break
            }
        }
        return workingCopy
    }
}
