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
// Puzzle.swift provides the a Puzzle generator for a standard Sudoku board.

import Foundation

/// Sudoku puzzle generator
public struct Puzzle {
    public let puzzle: Board


    /// Initializer to generate a puzzle with the given number of or the closest option.
    /// - Parameter given: the number of given cells
    public init?(given: Int = 36) {
        func makePuzzle(board: Board, with given: Int, candidates: [Int] = [Int](0..<81), fixed: [Int] = [Int]()) -> Board? {
            guard fixed.count <= given else {
                // Not possible to generate a puzzle with the requested number of given numbers.
                return nil
            }
            var puzzle = board
            let copyPuzzle = puzzle
            var candidates = candidates.shuffled()
            var fixed = fixed

            while candidates.count > 0 {
                let erase = candidates.removeLast()
                puzzle[erase] = 0
                let solutions = solver.solve(puzzle: puzzle)
                if solutions.count == 1 {
                    if fixed.count + candidates.count == given {
                        return puzzle
                    }
                    if let result = makePuzzle(board: puzzle, with: given, candidates: candidates, fixed: fixed) {
                        return result
                    }
                }
                fixed.append(erase)
                guard fixed.count <= given else {
                    return nil
                }
                puzzle = copyPuzzle
            }
            return nil
        }

        precondition((17...46).contains(given), "The number of given positions should be in the range 17...46.")
        guard let solution = Board() else {
            return nil
        }
        let solver = Solver()
        guard let puzzle = makePuzzle(board: solution, with: given) else {
            return nil
        }
        self.puzzle = puzzle

    }
}
