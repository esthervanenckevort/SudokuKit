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
// SolverTests.swift provides unit tests for Solver.swift.

import Foundation
import XCTest
import SudokuKit

final class SolverTests: XCTestCase {
    /// Puzzle from Sudoku iOS App [https://apps.apple.com/us/app/sudoku/id366247306]
    private let solution = [
        5, 6, 8, 2, 4, 7, 9, 1, 3,
        3, 4, 2, 1, 9, 5, 6, 8, 7,
        1, 9, 7, 8, 6, 3, 2, 5, 4,
        6, 8, 5, 3, 1, 2, 4, 7, 9,
        7, 3, 4, 9, 5, 8, 1, 6, 2,
        2, 1, 9, 6, 7, 4, 5, 3, 8,
        9, 2, 6, 7, 8, 1, 3, 4, 5,
        4, 7, 3, 5, 2, 6, 8, 9, 1,
        8, 5, 1, 4, 3, 9, 7, 2, 6
    ]
    private let board = Board(board: [
        0, 0, 8, 2, 0, 0, 9, 0, 3,
        3, 4, 2, 0, 9, 5, 0, 0, 7,
        1, 9, 7, 0, 0, 0, 0, 0, 4,
        0, 0, 5, 3, 1, 2, 4, 7, 9,
        0, 0, 0, 0, 0, 0, 0, 0, 0,
        2, 0, 0, 0, 7, 4, 5, 0, 0,
        0, 2, 0, 0, 0, 1, 0, 0, 5,
        0, 7, 0, 0, 0, 6, 8, 9, 1,
        8, 0, 0, 4, 3, 0, 7, 0, 6
    ])

    /// Puzzle from SudokuWiki.org weekly 'Unsolvable'  [https://www.sudokuwiki.org/Weekly_Sudoku.asp]
    private let diabolical = Board(board: [
        4, 0, 0, 0, 0, 9, 2, 0, 0,
        0, 0, 0, 0, 1, 0, 0, 8, 0,
        0, 0, 5, 4, 0, 0, 0, 0, 6,
        0, 0, 4, 2, 0, 0, 0, 0, 1,
        0, 5, 0, 0, 3, 0, 0, 6, 0,
        7, 0, 0, 0, 0, 5, 3, 0, 0,
        5, 0, 0, 0, 0, 7, 6, 0, 0,
        0, 9, 0, 0, 6, 0, 0, 0, 0,
        0, 0, 2, 8, 0, 0, 0, 0, 7

    ])
    func testSolve() {
        let sudoku = Sudoku()
        measure {
            let results = sudoku.solve(puzzle: board)

            XCTAssert(results.count == 1, "Solver should return exactly one result, but received \(results.count) results.")
            if results.count == 1 {
                for index in 0..<81 {
                    XCTAssert(results[0][index] == solution[index], "Solver solution should match given solution.")
                }
            }
        }
    }

    func testDiabolical() {
        let sudoku = Sudoku()
        measure {
            let results = sudoku.solve(puzzle: diabolical)
            XCTAssert(results.count == 1, "Solver should return exactly one result, but received \(results.count) results.")
        }
    }

    func testSolveSolvedPuzzle() {
        let sudoku = Sudoku()
        let solved = Board(board: solution)
        let results = sudoku.solve(puzzle: solved)
        XCTAssert(results.count == 1, "Solver should return exactly one result, but received \(results.count) results.")
    }

    func testSolveInvalidPuzzle() {
        var invalid = solution
        invalid[80] = 7
        let invalidBoard = Board(board: invalid)
        let sudoku = Sudoku()
        let results = sudoku.solve(puzzle: invalidBoard)
        XCTAssert(results.count == 0, "Solver should return no solutions, actually returned \(results.count) solutions.")
    }
}
