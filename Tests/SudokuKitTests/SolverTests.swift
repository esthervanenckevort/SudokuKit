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


    func testSolve() {
        let sudoku = Sudoku()
        measure {
            let results = sudoku.solve(puzzle: Board.board11)

            XCTAssert(results.count == 1, "Solver should return exactly one result, but received \(results.count) results.")
            if results.count == 1 {
                for index in 0..<81 {
                    XCTAssert(results[0][index] == solution[index], "Solver solution should match given solution.")
                }
            }
        }
    }

    func testSolveSimpleCases() {
        let sudoku = Sudoku()
        let boards = Board.simple()
        for board in boards {
            let results = sudoku.solve(puzzle: board)
            XCTAssert(results.count == 1, "Solver should return exactly one result, but received \(results.count) results.")
        }
    }
    
    func testSolveEasyCases() {
        let sudoku = Sudoku()
        for board in Board.easy() {
            let results = sudoku.solve(puzzle: board)
            XCTAssert(results.count == 1, "Solver should return exactly one result, but received \(results.count) results.")
        }
    }

    func testSolveIntermediateCases() {
        let sudoku = Sudoku()
        for board in Board.intermediate() {
            let results = sudoku.solve(puzzle: board)
            XCTAssert(results.count == 1, "Solver should return exactly one result, but received \(results.count) results.")
        }
    }

    func testSolveExpertCases() {
        let sudoku = Sudoku()
        for board in Board.expert() {
            let results = sudoku.solve(puzzle: board)
            XCTAssert(results.count == 1, "Solver should return exactly one result, but received \(results.count) results.")
        }
    }

    func testDiabolical() {
        let sudoku = Sudoku()
        let results = sudoku.solve(puzzle: Board.board12)
        XCTAssert(results.count == 1, "Solver should return exactly one result, but received \(results.count) results.")
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
