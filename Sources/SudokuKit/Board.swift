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
    private var board: [Int]
    private let boardWidth = 9
    private let boardRange = 0..<81
    private let squareWidth = 3

    /// Get the numbers in the square for the given position.
    /// - Parameter index: The position in the range 0...80 for which to retreive the square.
    /// - Returns: An array with the nine values in rowwise order
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


    /// Get the numbers in the row for the given position.
    /// - Parameter index: The position in the range 0...80 for which to retreive the row.
    /// - Returns: An array with the nine values from left to right.
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

    /// Get the numbers in the column for the given position.
    /// - Parameter index: The position in the range 0...80 for which to retreive the column
    /// - Returns: An array with the nine values from top to bottom.
    public func getColumn(for index: Int) -> [Int] {
        precondition((0..<81).contains(index), "Index must be in range 0..<81")
        let startIndex = index % boardWidth
        var elements = Array<Int>.init(repeating: 0, count: boardWidth)
        for offset in 0..<9 {
            elements[offset] = board[startIndex + offset * boardWidth]
        }
        return elements
    }

    /// Direct access to the board
    public subscript(index: Int) -> Int {
        get {
            precondition((0..<81).contains(index), "Index must be in range 0..<81")
            return board[index]
        }
        set(newValue) {
            precondition((0..<81).contains(index), "Index must be in range 0..<81")
            precondition((0...9).contains(newValue), "The new value must be in the range 0...9")
            board[index] = newValue
        }
    }

    /// Initialize a board with the given array.
    ///
    /// - Parameter board: an array containing an existing board with the numbers 0 - 9, where 0
    ///                    indicates an empty field.
    public init(board: [Int]) {
        precondition(board.count == 81, "Board must have exactly 81 elements.")
        precondition(board.reduce(true) { (0...9).contains($1) }, "Board must only contain elements in the range 0...9")
        self.board = board
    }


    /// Check if this board is a valid solution.
    /// - Returns: true if the board is a valid solution, which means all fields are filled with a number in
    ///            the range 1...9 and each row and each column contains each of the numbers only
    ///            once.
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


    /// Generate a new random board with a valid solution. This implementation uses a random seed and
    /// a backtrace solver to generate a valid solution. This should never return nil.
    public init?() {
        /// Recursively resolve the given board to a valid solution.
        /// - Parameters:
        ///   - board: A board that contains each of the numbers from 1...9 in each square.
        ///   - position: Position to start resolving.
        /// - Returns: A valid board or nil if no solution was found.
        func resolve(board: [Int], from position: Int) -> [Int]? {
            guard position < board.count else {
                return board
            }
            var result: [Int]?
            let seen = collectSeenNumbers(for: position, on: board)
            if seen.contains(board[position]) {
                result = swapNumber(at: position, on: board, excluding: seen)
            } else {
                result = resolve(board: board, from: position + 1)
                if result == nil {
                    result = swapNumber(at: position, on: board, excluding: seen)
                }
            }
            return result
        }

        /// Collect all the numbers that were seen in the in column and row before the given position.
        /// - Parameters:
        ///   - position: Position for which the seen numbers should be returned.
        ///   - board: The board being used.
        /// - Returns: A set of numbers in the range 1...9
        func collectSeenNumbers(for position: Int, on board: [Int]) -> Set<Int> {
            var seen = Set<Int>()
            // Row
            let rowStart = (position / 9) * 9
            for index in rowStart..<position {
                seen.insert(board[index])
            }
            // Column
            for index in stride(from: position % 9, to: position, by: 9) {
                seen.insert(board[index])
            }
            return seen
        }

        /// Swap the number at the given position with another number in the same square
        /// - Parameters:
        ///   - position: The position of the number to swap.
        ///   - board: The board being used.
        ///   - seen: Numbers that have already been seen in the row and column and can not be
        ///           swapped in at this position.
        /// - Returns: A new version of the board with the number swapped or nil if no swap was
        /// possible.
        func swapNumber(at position: Int, on board: [Int], excluding seen: Set<Int>) -> [Int]? {
            var searchPos = position
            var result: [Int]?
            repeat {
                if searchPos % 3 == 2 {
                    searchPos += 7
                } else {
                    searchPos += 1
                }
                guard searchPos < board.count && inSameSquare(position, searchPos) else {
                    return nil
                }
                if !seen.contains(board[searchPos]) {
                    var newBoard = board
                    newBoard.swapAt(position, searchPos)
                    result = resolve(board: newBoard, from: position + 1)
                }
            } while result == nil
            return result
        }

        /// Check if two positions are in the same square.
        /// - Parameters:
        ///   - first: First position to consider.
        ///   - second: Second position to consider
        /// - Returns: true if they are in the same square, false otherwise.
        func inSameSquare(_ first: Int, _ second: Int) -> Bool {
            let column1 = first % 9 / 3
            let row1 = first / 27
            let column2 = second % 9 / 3
            let row2 = second / 27
            return column1 == column2 && row1 == row2
        }

        /// Fill a board with nine squares each having the numbers 1...9.
        /// - Returns: A filled board, which is most likely not a valid Sudoku square.
        func fill() -> [Int] {
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

        guard let board = resolve(board: fill(), from: 0) else {
            return nil
        }
        self.board = board
    }
}

extension Board: CustomStringConvertible {

    /// Description of the board. A 9 x 9 square divided in 9 3 x 3 squares with the numbers 0...9 printed.
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
