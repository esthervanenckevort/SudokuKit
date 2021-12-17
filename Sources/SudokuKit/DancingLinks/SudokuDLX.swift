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

public final class SudokuDLX {
    let size: Int
    let boxSize: Int
    let constraints = 4
    let minValue = 1
    let maxValue: Int
    let grid: [[Int]]

    enum ValidationError: Error {
        case invalidLine(_ message: String)
        case invalidSize(_ message: String)
    }

    public init(_ grid: [[Int]]) throws {
        self.grid = grid
        self.size = self.grid.count
        self.boxSize = Int(sqrt(Double(self.size)))
        self.maxValue = self.size
        guard boxSize * boxSize == size else { throw ValidationError.invalidSize("Size of the grid is not valid") }
        for line in grid {
            guard line.count == size else { throw ValidationError.invalidLine("Size of line is not valid") }
        }
    }

    public func solve() -> [[[Int]]] {
        let cover = convertToCoverMatrix(grid)
        var solutions = [[[Int]]]()
        guard let dlx = DancingLinks(cover: cover) else { return solutions }
        dlx.solve {
            solutions.append(convertDLXListToGrid($0))
        }
        return solutions
    }

    private func convertToCoverMatrix(_ grid: [[Int]]) -> [[Int]] {
        var coverMatrix = makeCoverMatrix()
        for row in 0..<size {
            for column in 0..<size {
                let value = grid[row][column]
                guard value != 0 else { continue }
                for num in minValue...maxValue {
                    guard num != value else { continue }
                    let idx = index(row: row, column: column, position: num - 1)
                    coverMatrix[idx] = [Int].init(repeating: 0, count: size * size * constraints)
                }
            }
        }
        return coverMatrix
    }

    private func convertDLXListToGrid(_ solution: ContiguousArray<DancingNode>) -> [[Int]] {
        var result = [[Int]].init(repeating: [Int].init(repeating: 0, count: size), count: size)
        for node in solution {
            var rcNode = node
            var min = node.column.value
            var tmp = node.right
            while (tmp != node) {
                if (tmp.column.value < min) {
                    min = tmp.column.value
                    rcNode = tmp
                }
                tmp = tmp.right
            }
            let row = rcNode.column!.value / size
            let column = rcNode.column!.value % size
            let value = rcNode.right.column!.value % size + 1
            result[row][column] = value
        }
        return result
    }

    private func index(row: Int, column: Int, position: Int) -> Int {
        return row * size * size + column * size + position
    }

    private func makeCoverMatrix() -> [[Int]]  {
        var matrix = [[Int]].init(repeating: [Int].init(repeating: 0, count: size * size * constraints), count: size * size * maxValue)
        var header = 0

        func setBoxConstraints() {
            for row in stride(from: 0, to: size, by: boxSize) {
                for column in stride(from: 0, to: size, by: boxSize)  {
                    for position in 0..<size {
                        for rowDelta in 0..<boxSize {
                            for columnDelta in 0..<boxSize {
                                let idx = index(row: row + rowDelta, column: column + columnDelta, position: position)
                                matrix[idx][header] = 1
                            }
                        }
                        header += 1
                    }
                }
            }
        }

        func setColumnConstraints() {
            for column in 0..<size {
                for position in 0..<size {
                    for row in 0..<size {
                        let idx = index(row: row, column: column, position: position)
                        matrix[idx][header] = 1
                    }
                    header += 1
                }
            }
        }

        func setRowConstraints() {
            for row in 0..<size {
                for position in 0..<size {
                    for column in 0..<size {
                        let idx = index(row: row, column: column, position: position)
                        matrix[idx][header] = 1
                    }
                    header += 1
                }
            }
        }

        func setCellConstraints() {
            for row in 0..<size {
                for column in 0..<size {
                    for position in 0..<size {
                        let idx = index(row: row, column: column, position: position)
                        matrix[idx][header] = 1
                    }
                    header += 1
                }
            }
        }

        setCellConstraints()
        setRowConstraints()
        setColumnConstraints()
        setBoxConstraints()

        return matrix
    }
}
