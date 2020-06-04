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
// PuzzleTests.swift provides unit tests for Puzzle.swift.

import Foundation
import XCTest
import SudokuKit

final class PuzzleTests: XCTestCase {
    func testGeneratePuzzle() {
        let solver = Solver()
        for given in (25...46).reversed() {
            print("Generate puzzle with \(given) given numbers.")
            guard let puzzle = Puzzle(given: given) else {
                XCTFail("Failed to generate puzzle with \(given) given numbers.")
                continue
            }
            XCTAssert(puzzle.puzzle.board.filter { $0 != 0 }.count == given, "Puzzle should have \(given) given numbers.")
            XCTAssert(solver.solve(puzzle: puzzle.puzzle).count == 1, "Puzzle must have exactly one solution.")
            print(puzzle.puzzle)
        }
    }
}
