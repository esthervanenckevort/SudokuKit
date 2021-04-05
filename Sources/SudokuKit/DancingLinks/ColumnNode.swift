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

final class ColumnNode: DancingNode {
    var size: Int
    let value: Int

    init(value: Int) {
        self.size = 0
        self.value = value
        super.init()
        self.column = self
    }

    func cover() {
        removeLeftRight()
        var bottomNode = bottom
        while (bottomNode != self) {
            var rightNode = bottomNode.right
            while (rightNode != bottomNode) {
                rightNode.removeTopBottom()
                rightNode.column.size -= 1
                rightNode = rightNode.right
            }
            bottomNode = bottomNode.bottom
        }
    }

    func uncover() {
        var topNode = top
        while (topNode != self) {
            var leftNode = topNode.left
            while (leftNode != topNode) {
                right.column.size += 1
                leftNode.reinsertTopBottom()
                leftNode = leftNode.left
            }
            topNode = topNode.top
        }
        reinsertLeftRight()
    }
}
