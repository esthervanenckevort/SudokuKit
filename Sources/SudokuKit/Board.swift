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
