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


/// Implementation of a Sudoku solver
public struct Solver {

    /// Initializer for the standard Sudoku solver.
    public init() {
    }

    /// Backtrace based solver for a traditional Sudoku.
    /// - Parameter puzzle: the puzzle to solve.
    /// - Returns: An array of solutions for the puzzle.
    public func solve(puzzle: Board) -> [Board] {

        /// Recursive solver.
        /// - Parameters:
        ///   - index: Index of the first cell to solve.
        ///   - puzzle: The puzzle to solve.
        /// - Returns: An array of solutions.
        func solve(startingFrom index: Int, puzzle: Board) -> [Board] {
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

        /// Update the board by placing a number. This will call solve if successfully placed the number.
        /// - Parameters:
        ///   - number: The number to place.
        ///   - index: The position to place the number.
        ///   - board: the board to solve.
        /// - Returns: An array of solutions based on placing this number.
        func place(number: Int, at index: Int, on board: Board) -> [Board] {
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

        return solve(startingFrom: 0, puzzle: puzzle)
    }
}
