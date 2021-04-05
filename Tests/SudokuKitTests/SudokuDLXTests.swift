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


import Foundation
import XCTest
import SudokuKit

final class SudokuDLXTests: XCTestCase {
    let grid9 = (
        name: "Sudoku 9x9",
        problem: [
            [0, 0, 8, 2, 0, 0, 9, 0, 3],
            [3, 4, 2, 0, 9, 5, 0, 0, 7],
            [1, 9, 7, 0, 0, 0, 0, 0, 4],
            [0, 0, 5, 3, 1, 2, 4, 7, 9],
            [0, 0, 0, 0, 0, 0, 0, 0, 0],
            [2, 0, 0, 0, 7, 4, 5, 0, 0],
            [0, 2, 0, 0, 0, 1, 0, 0, 5],
            [0, 7, 0, 0, 0, 6, 8, 9, 1],
            [8, 0, 0, 4, 3, 0, 7, 0, 6]
        ],
        solutions: 1)
    let grid4 = (
        name: "Sudoku 4x4",
        problem: [
        [1, 2, 3, 4],
        [3, 4, 1, 0],
        [0, 1, 4, 3],
        [0, 0, 0, 0]
    ],
    solutions: 1)

    let empty = (
        name: "Empty Sudoku 4x4",
        problem: [
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0]
    ], solutions: 288)

    func testSolve() throws {
        for (name, problem, solutions) in [grid9] {
            do {
                print("=== Testing \(name) ===")
                let sudoku = try SudokuDLX(problem)
                let result = sudoku.solve()
                XCTAssert(result.count == solutions, "There should be \(solutions) for \(name), actual result \(result.count) solution(s).")
                print("=== Testing \(name) done ===")
            } catch {
                XCTFail("Failed \(name) with \(error).")
            }
        }
    }

    func testPerformance() {
        measure {
            do {
                print("=== Testing \(grid9.name) ===")
                let sudoku = try SudokuDLX(grid9.problem)
                let result = sudoku.solve()
                XCTAssert(result.count == grid9.solutions, "There should be \(grid9.solutions) for \(grid9.name), actual result \(result.count) solution(s).")
                print("=== Testing \(grid9.name) done ===")
            } catch {
                XCTFail("Failed \(grid9.name) with \(error).")
            }
        }
    }
}
