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
// PlayingBoard.swift manages the Sudoku playing board.

import Foundation

/// PlayingBoard
public struct PlayingBoard {

    /// The state of the cell
    public enum CellState: Equatable {
        /// The cell contains a fixed number.
        case fixed(Int)
        /// The cell contains annotations
        case annotations(Set<Int>)
        /// The cell contains a proposed solution
        case solution(Int)
    }

    /// The state of the Game.
    public enum GameState {
        /// The puzzle has not yet been completed
        case playing
        /// The puzzle has been correctly solved
        case solved
        /// The puzzle has been completed, but the solution was invalid
        case invalid
    }

    /// The puzzle represented in this board
    private let puzzle: Puzzle

    /// PlayingBoard on which the player plays.
    private var board: [[CellState]]

    /// State of this PlayingBoard
    public private(set) var state = GameState.playing

    public subscript(row: Int, column: Int) -> CellState {
        precondition((0..<9).contains(row), "The row must be in the range 0..<9.")
        precondition((0..<9).contains(column), "The column must be in the range 0..<9.")
        return board[row][column]
    }

    public mutating func mark(row: Int, column: Int, with value: Int, asAnnotation annotating: Bool = false) {
        precondition((0..<9).contains(row), "The row must be in the range 0..<9.")
        precondition((0..<9).contains(column), "The column must be in the range 0..<9.")
        guard state == .playing else { return }
        switch board[row][column] {
        case .fixed(_):
            return
        case .annotations(var values):
            if annotating {
                values.toggle(value)
                board[row][column] = .annotations(values)
            } else {
                board[row][column] = .solution(value)
                clear(mark: value, row: row, column: column)
            }
        case .solution(let currentValue):
            if value != currentValue {
                if annotating {
                    board[row][column] = .annotations(Set([value]))
                } else {
                    board[row][column] = .solution(value)
                    clear(mark: value, row: row, column: column)
                }
            } else {
                board[row][column] = .annotations(Set.empty)
            }
        }
    }

    private mutating func clear(mark: Int, row: Int, column: Int) {
        enum Visit: CaseIterable {
            case row, column, square
        }

        for visit in Visit.allCases {
            for position in 0..<9 {
                var currentRow: Int
                var currentColumn: Int
                switch visit {
                case .row:
                    currentRow = row
                    currentColumn = position
                case .column:
                    currentRow = position
                    currentColumn = column
                case .square:
                    let firstColumn = column / 3 * 3
                    let firstRow = row / 3 * 3
                    currentColumn = firstColumn + position % 3
                    currentRow = firstRow + position / 3
                }

                guard !(currentColumn == column && currentRow == row) else { continue }
                switch board[currentRow][currentColumn] {
                case .fixed:
                    continue
                case .annotations(var values):
                    values.remove(mark)
                    board[currentRow][currentColumn] = .annotations(values)
                case .solution(let currentValue):
                    if currentValue == mark {
                        board[currentRow][currentColumn] = .annotations(.empty)
                    }
                }
            }
        }

    }




    /// Submit the game as solved.
    /// - Returns: The game state, either GameState.solved or GameState.invaldi
    public mutating func submit() -> GameState {
        guard state == .playing else { return state }
        var solution = [Int]()
        solution.reserveCapacity(81)
        for row in 0..<9 {
            for column in 0..<9 {
                switch board[row][column] {
                case .fixed(let value), .solution(let value):
                    solution.append(value)
                case .annotations(_):
                    state = .invalid
                    return state
                }
            }
        }
        let board = Board(board: solution)
        state = board.isValidSolution() ? .solved : .invalid
        return state
    }


    /// Reveal if the given position has been solved. If the game has not yet been submitted this method will return
    /// nil.
    /// - Parameters:
    ///   - row: The row in the range 0...8 of the cell to check
    ///   - column: The column in the range 0...8 of the cell to check
    /// - Returns: Returns nil if the game is still in play or true if the position is correct, false if it is incorrect
    public func isCorrect(row: Int, column: Int) -> Bool? {
        precondition((0..<9).contains(row), "The row must be in the range 0..<9.")
        precondition((0..<9).contains(column), "The column must be in the range 0..<9.")
        guard state != .playing else { return nil }
        switch board[row][column] {
        case .fixed(_):
            return true
        case .annotations(_):
            return false
        case .solution(let value):
            return value == puzzle.solution[row * 9 + column]
        }
    }


    /// Checks if the given value is valid for the position based on the already solved and given values.
    /// - Parameters:
    ///   - value: The value to check.
    ///   - row: The row in the range 0...8 of the cell to check
    ///   - column: The column in the range 0...8 of the cell to check
    /// - Returns: If the value is valid this will return true, false otherwise.
    public func isValidOption(value: Int, forRow row: Int, column: Int) -> Bool {
        precondition((1...9).contains(value), "The value must be in the range 1...9.")
        precondition((0..<9).contains(row), "The row must be in the range 0..<9.")
        precondition((0..<9).contains(column), "The column must be in the range 0..<9.")
        return !inRow(value: value, row: row) && !inColumn(value: value, column: column) && !inSquare(value: value, row: row, column: column)
    }

    /// Check if the given value is already present in the row.
    /// - Parameter value: The value to check (range 1...9)
    /// - Parameter row: The row to check (range 0...8)
    /// - Returns:  If the value is valid this will return true, false otherwise.
    private func inRow(value: Int, row: Int) -> Bool {
        for index in 0..<9 {
            guard check(row: row, column: index, with: value) else { continue }
            return true
        }
        return false
    }

    /// Check if the given value is already present in the column.
    /// - Parameter value: The value to check (range 1...9)
    /// - Parameter column: The column to check (range 0...8)
    /// - Returns:If the value is present this will return true, false otherwise.
    private func inColumn(value: Int, column: Int) -> Bool {
        for index in 0..<9 {
            guard check(row: index, column: column, with: value) else { continue }
            return true
        }
        return false
    }

    /// Check if the given value is already present in the square.
    /// - Parameters:
    ///   - value: The value to check (range 1...9)
    ///   - row: The row to check (range 0...8)
    ///   - column: The column to check (range 0...8)
    /// - Returns: If the value is present this will return true, false otherwise.
    private func inSquare(value: Int, row: Int, column: Int) -> Bool {
        let topRow = row / 3 * 3
        let bottomRow = topRow + 2
        let leftColumn = column / 3 * 3
        let rightColumn = leftColumn + 2
        
        for row in topRow...bottomRow {
            for column in leftColumn...rightColumn {
                guard check(row: row, column: column, with: value) else { continue }
                return true
            }
        }
        return false
    }


    /// Check if the given column matches the value.
    /// - Parameters:
    ///   - row: The row to check (range 0...8)
    ///   - column: The column to check (range 0...8)
    ///   - value: The value to check (range 1...9)
    /// - Returns: True if the given position has a fixed or selected value that is equal to the given value.
    private func check(row: Int, column: Int, with value: Int) -> Bool {
        switch board[row][column] {
        case .fixed(let number), .solution(let number):
            return number == value
        case .annotations(_):
            return false
        }
    }

    /// Initialize a new game.
    /// - Parameter given: Number of given squares.
    public init(given: Int = 36) {
        guard let puzzle = Puzzle(given: given) else {
            fatalError("Failed to generate a new puzzle.")
        }
        self.init(puzzle: puzzle)
    }

    /// Initializer to create a playing board with a given puzzle.
    /// - Parameter puzzle: The puzzle to play.
    public init(puzzle: Puzzle) {
        self.puzzle = puzzle
        board = [[CellState]]()
        board.reserveCapacity(81)
        for index in 0..<81 {
            if index % 9 == 0 {
                board.append([CellState]())
            }
            let cell = puzzle.board[index] == 0 ? CellState.annotations(Set()) : CellState.fixed(puzzle.board[index])
            board[index / 9].append(cell)
        }
    }
}

fileprivate extension Set {
    /// Convenience empty set.
    static var empty: Set { return Self() }

    /// Toggle the set. Remove the value if it is present or insert it if it was not present.
    /// - Parameter value: The value to toggle.
    mutating func toggle(_ value: Element) {
        if contains(value) {
            remove(value)
        } else {
            insert(value)
        }
    }
}
