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

extension Board {

    static let board1 = Board(board: [
        0, 0, 0, 7, 0, 2, 0, 0, 0,
        3, 0, 0, 0, 4, 0, 0, 0, 6,
        4, 0, 6, 5, 0, 0, 0, 0, 0,
        0, 0, 5, 0, 2, 0, 0, 9, 3,
        0, 2, 0, 0, 0, 0, 0, 8, 0,
        1, 6, 0, 0, 5, 0, 4, 0, 0,
        0, 0, 0, 0, 0, 8, 3, 0, 1,
        6, 0, 0, 0, 9, 0, 0, 0, 7,
        0, 0, 0, 2, 0, 5, 0, 0, 0])
    static let board2 = Board(board: [
        0, 0, 0, 0, 0, 0, 5, 0, 0,
        0, 8, 0, 0, 0, 7, 0, 0, 2,
        0, 0, 7, 0, 3, 4, 0, 0, 0,
        0, 0, 0, 0, 0, 3, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 2, 1,
        0, 1, 0, 0, 9, 0, 6, 3, 5,
        0, 3, 6, 0, 4, 0, 1, 0, 0,
        4, 0, 0, 0, 0, 0, 0, 5, 7,
        0, 0, 8, 0, 2, 0, 0, 0, 0])
    static let board3 = Board(board: [0,5,0,0,9,2,0,0,0,0,6,0,4,0,8,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,6,5,0,0,0,3,0,0,0,4,8,0,8,1,0,0,0,0,0,0,7,0,0,0,0,7,0,2,0,0,2,0,0,6,0,5,8,0,0,7,0,0,0,0,9,0,6,0])
    static let board4 = Board(board: [0,7,4,0,2,0,0,0,0,0,0,0,9,6,0,7,0,0,3,8,0,0,0,0,0,2,0,0,9,0,0,0,0,0,0,5,2,0,0,1,4,0,0,6,0,0,0,1,0,0,0,0,0,0,0,0,0,7,0,4,0,1,0,0,0,5,8,0,0,0,0,0,0,0,0,0,0,6,4,3,0])
    static let board5 = Board(board: [0,3,0,0,0,2,0,6,4,8,0,0,0,0,0,0,0,3,0,7,0,0,8,3,0,0,2,0,0,0,0,0,4,0,0,0,0,0,2,0,1,6,0,8,0,0,9,0,2,3,0,0,0,0,0,6,0,0,0,0,5,0,8,0,0,0,0,6,9,0,4,0,0,0,0,4,0,0,1,0,0])
    static let board6 = Board(board: [3,0,0,0,2,0,0,0,4,0,1,2,9,0,0,0,0,0,0,0,6,0,0,1,3,0,0,1,0,0,0,0,0,0,0,0,0,0,3,0,0,0,7,6,0,6,0,0,0,0,2,0,9,0,0,8,1,0,0,7,0,2,5,2,0,0,0,4,0,0,0,0,0,0,7,0,0,0,0,0,0])
    static let board7 = Board(board: [5,2,0,0,0,0,0,8,4,0,9,0,7,0,0,2,5,0,0,0,0,0,0,2,0,0,1,0,0,6,0,0,0,7,0,0,0,0,0,4,7,8,0,0,0,0,4,0,0,0,9,0,3,0,9,8,0,0,0,7,0,0,0,1,0,0,0,0,0,0,0,3,0,0,0,9,0,0,0,0,0])
    static let board8 = Board(board: [0,7,0,1,0,0,0,0,6,0,5,0,2,0,0,0,0,3,4,0,2,0,0,0,0,0,0,1,0,3,0,5,0,0,0,0,0,0,9,6,0,7,0,0,0,5,0,0,0,0,0,0,1,0,0,0,0,0,0,2,7,5,9,0,0,0,9,0,0,0,0,8,0,0,0,0,3,0,2,0,0])
    static let board9 = Board(board: [0,8,0,0,0,0,0,3,0,7,0,4,0,0,0,0,0,0,0,0,0,5,0,0,0,6,0,0,0,1,0,0,6,0,0,0,9,0,0,3,4,0,0,0,0,0,7,0,8,0,0,2,0,0,0,0,8,0,0,3,4,2,0,0,4,0,0,0,0,9,1,0,0,0,0,2,5,0,0,0,0])
    static let board10 = Board(board: [1,0,0,0,2,0,0,0,0,0,6,9,0,0,8,5,0,0,2,8,0,0,0,9,7,0,0,0,0,0,3,4,0,0,0,0,0,5,0,0,0,6,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,0,6,0,0,0,9,0,0,0,0,0,5,7,0,0,6,0,0,7,0,8,9])
    static let board11 = Board(board: [
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
    static let board12 = Board(board: [
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
//    static let allBoards = [ board1, board2, board3, board4, board5, board6,
//    board7, board8, board9, board10, board11, board12]
    static func load(file: String) -> [Board] {
        let puzzles = try! String(contentsOf: Bundle.module.url(forResource: "testcases/\(file)", withExtension: "txt")!)
        var boards = [Board]()
        for puzzle in puzzles.split(separator: "\n") {
            let board = puzzle.replacingOccurrences(of: ".", with: "0").compactMap { Int(String($0)) }
            boards.append(Board(board: board))
        }
        return boards
    }

    static func simple() -> [Board] {
        load(file: "simple")
    }

    static func easy() -> [Board] {
        load(file: "easy")
    }

    static func intermediate() -> [Board] {
        load(file: "intermediate")
    }

    static func expert() -> [Board] {
        load(file: "expert")
    }
}
