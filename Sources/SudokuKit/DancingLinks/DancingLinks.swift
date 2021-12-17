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

public final class DancingLinks {
    private var header: ColumnNode
    private var answer = ContiguousArray<DancingNode>()

    public init?(cover: [[Int]]) {
        guard let columns = cover.first?.count else { return nil }
        var headerNode = ColumnNode(value: -1)
        var columnNodes = [ColumnNode]()

        for count in 0..<columns {
            let node = ColumnNode(value: count)
            columnNodes.append(node)
            headerNode = headerNode.linkRight(node) as! ColumnNode
        }
        headerNode = headerNode.right.column

        for grid in cover {
            var previous: DancingNode! = nil

            for (index, cell) in grid.enumerated() {
                guard cell == 1 else { continue }
                let column = columnNodes[index]
                let newNode = DancingNode()
                newNode.column = column
                if previous == nil {
                    previous = newNode
                }
                _ = column.top.linkDown(newNode)
                previous = previous.linkRight(newNode)
                column.size += 1
            }
        }
        headerNode.size = columns
        header = headerNode
    }

    public func solve(handler: (ContiguousArray<DancingNode>) -> ()) {
        if header.right == header {
            handler(answer)
        } else {
            var column = selectColumn()
            column.cover()

            var line = column.bottom
            while (line != column) {
                answer.append(line)

                var rightNode = line.right
                while (rightNode != line) {
                    rightNode.column.cover()
                    rightNode = rightNode.right
                }

                solve(handler: handler)
                line = answer.removeLast()
                column = line.column

                var leftNode = line.left
                while (leftNode != line) {
                    leftNode.column.uncover()
                    leftNode = leftNode.left
                }

                line = line.bottom
            }

            column.uncover()
        }
    }

    func selectColumn() -> ColumnNode {
        var min = Int.max
        var selected: ColumnNode!
        var temp: ColumnNode = header.right as! ColumnNode
        while temp != header {
            if temp.size < min {
                min = temp.size
                selected = temp
            }
            temp = temp.right as! ColumnNode
        }
        return selected
    }
}
