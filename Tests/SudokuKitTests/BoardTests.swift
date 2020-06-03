import Foundation
import XCTest
import SudokuKit

final class BoardTests: XCTestCase {

    var board: Board!
    override func setUp() {
        board = Board(board: [
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
    }
    func testGetSquare() {
        let square1 = [0, 0, 8, 3, 4, 2, 1, 9, 7]
        let square9 = [0, 0, 5, 8, 9, 1, 7, 0, 6]
        let square1Indices = [0, 1, 2, 9, 10, 11, 18, 19, 20]
        let square9Indices = [60, 61, 62, 69, 70, 71, 78, 79, 80]
        for index in square1Indices {
            let result = board.getSquare(for: index)
            XCTAssert(result == square1, "Result for index \(index) must be equal to square1.")
        }
        for index in square9Indices {
            let result = board.getSquare(for: index)
            XCTAssert(result == square9, "Result for index \(index) must be equal to square9.")
        }
    }

    func testGetRow() {
        let row1 = [0, 0, 8, 2, 0, 0, 9, 0, 3]
        let row9 = [8, 0, 0, 4, 3, 0, 7, 0, 6]
        for index in 0..<9 {
            let result = board.getRow(for: index)
            XCTAssert(result == row1, "Result for index \(index) must be equal to row1.")
        }
        for index in 72..<81 {
            let result = board.getRow(for: index)
            XCTAssert(result == row9, "Result for index \(index) must be equal to row9.")
        }
    }

    func testGetColumn() {
        let column1 = [0, 3, 1, 0, 0, 2, 0, 0, 8]
        let column9 = [3, 7, 4, 9, 0, 0, 5, 1, 6]
        for index in stride(from: 0, through: 72, by: 9) {
            let result = board.getColumn(for: index)
            XCTAssert(result == column1, "Result for index \(index) must be equalt to column1.")
        }
        for index in stride(from: 8, through: 80, by: 9) {
            let result = board.getColumn(for: index)
            XCTAssert(result == column9, "Result for index \(index) must be equal to column9.")
        }
    }

    func testSubscript() {
        let results = [
            0, 0, 8, 2, 0, 0, 9, 0, 3,
            3, 4, 2, 0, 9, 5, 0, 0, 7,
            1, 9, 7, 0, 0, 0, 0, 0, 4,
            0, 0, 5, 3, 1, 2, 4, 7, 9,
            0, 0, 0, 0, 0, 0, 0, 0, 0,
            2, 0, 0, 0, 7, 4, 5, 0, 0,
            0, 2, 0, 0, 0, 1, 0, 0, 5,
            0, 7, 0, 0, 0, 6, 8, 9, 1,
            8, 0, 0, 4, 3, 0, 7, 0, 6
        ]
        for index in 0..<81 {
            let value = board[index]
            XCTAssert(value == results[index], "Result for index \(index) must be equal to the value in the array for the same index.")
        }
        for index in 0..<81 {
            board[index] = 255
            XCTAssert(board[index] == 255, "Board value must be successfully set to a different value.")
        }
    }

    func testGenerateBoard() {
        measure {
            for _ in 0..<1000 {
                guard let board = Board() else {
                    XCTFail("Should have generated a solution.")
                    return
                }
                if !board.isValidSolution() {
                    print(board)
                    XCTFail("Generated board should be a valid solution.")
                    return
                }
            }
        }
    }
}
