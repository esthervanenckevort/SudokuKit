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


import XCTest
@testable import SudokuKit

final class PlayingBoardTests: XCTestCase {

    func testInitializeWithDefaultPuzzle() throws {
        let board = PlayingBoard()
        XCTAssertTrue(board.state == PlayingBoard.GameState.playing, "Game must be in the playing state.")
        // Verify that the board is initialized by iterating over each cell
        for row in 0..<9 {
            for column in 0..<9 {
                // We ignore the result, since we just test that the board is initialized
                _ = board.isValidOption(value: 9, forRow: row, column: column)
            }
        }
    }

}
