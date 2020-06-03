import Foundation
import XCTest
import SudokuKit

final class SolverTests: XCTestCase {
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


    func testSolve() {
        let solver = Solver()
        let results = solver.solve(puzzle: board)
        XCTAssert(results.count == 1, "Solver should return exactly one result, but received \(results.count) results.")
        if results.count == 1 {
            for index in 0..<81 {
                XCTAssert(results[0][index] == solution[index], "Solver solution should match given solution.")
            }
        }
    }

    func testSolveSolvedPuzzle() {
        let solver = Solver()
        let solved = Board(board: solution)
        let results = solver.solve(puzzle: solved)
        XCTAssert(results.count == 1, "Solver should return exactly one result, but received \(results.count) results.")
    }

    func testSolveInvalidPuzzle() {
        var invalid = solution
        invalid[80] = 7
        let invalidBoard = Board(board: invalid)
        let solver = Solver()
        let results = solver.solve(puzzle: invalidBoard)
        XCTAssert(results.count == 0, "Solver should return no solutions, actually returned \(results.count) solutions.")
    }
}
