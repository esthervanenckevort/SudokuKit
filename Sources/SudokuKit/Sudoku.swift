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
// Solver.swift provides the a Solver for a standard Sudoku board.

import Foundation
/// Implementation of a Sudoku solver and generator.
public struct Sudoku {

    /// Initializer for the standard Sudoku solver.
    public init() {
    }

    /// Backtrace based solver for a traditional Sudoku.
    /// - Parameter puzzle: the puzzle to solve.
    /// - Returns: An array of solutions for the puzzle.
    public func solve(puzzle: Board) -> [Board] {
        var board = [[Int]]()
        let columns = Int(sqrt(Double(puzzle.board.count)))
        for index in 0..<puzzle.board.count {
            if index % columns == 0 {
                board.append([Int]())
            }
            let row = index / columns
            board[row].append(puzzle.board[index])
        }
        let dlx = try! SudokuDLX(board)
        let solutions = dlx.solve()
        return solutions.map { solution in
            Board(board: solution.reduce([Int]()) { (board, row) -> [Int] in
                return board + row
            })

        }
    }

    /// Generate a new random board with a valid solution. This implementation uses a random seed and
    /// a backtrace solver to generate a valid solution. This should never return nil.
    public func generate() -> Board? {
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
        return Board(board: board)
    }

}
