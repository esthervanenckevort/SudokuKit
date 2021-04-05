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
import SudokuKit
import ArgumentParser

struct Solver: ParsableCommand {

    @Argument(help: "File with the sudokus to solve.")
    var file: String

    mutating func run() throws {
        let solver = Sudoku()
        for board in load(file: file) {
            let solutions = solver.solve(puzzle: board)
            print(board)
            print("=== Solutions ===")
            for (index, solution) in solutions.enumerated() {
                print("#\(index)")
                print(solution)
            }
            print("=== Solutions ===")
        }
    }

    func load(file: String) -> [Board] {
        let puzzles = try! String(contentsOf: URL(fileURLWithPath: file))
        var boards = [Board]()
        for puzzle in puzzles.split(separator: "\n") {
            let board = puzzle.replacingOccurrences(of: ".", with: "0").compactMap { Int(String($0)) }
            boards.append(Board(board: board))
        }
        return boards
    }
}

Solver.main()
