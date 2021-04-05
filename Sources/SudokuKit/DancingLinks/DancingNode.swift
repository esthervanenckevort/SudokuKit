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

struct IdGenerator {
    private var current = 1
    mutating func next() -> Int {
        defer {
            current += 1
        }
        return current
    }
    static var shared = IdGenerator()
}

public class DancingNode: Equatable {
    public static func == (lhs: DancingNode, rhs: DancingNode) -> Bool {
        return rhs.id == lhs.id
    }

    var left, right, top, bottom: DancingNode!
    var column: ColumnNode!
    let id = IdGenerator.shared.next()

    init() {
        left = self
        right = self
        top = self
        bottom = self
    }

    func linkDown(_ node: DancingNode) -> DancingNode {
        node.bottom = self.bottom
        node.bottom?.top = node
        node.top = self
        self.bottom = node
        return node
    }

    func linkRight(_ node: DancingNode) -> DancingNode {
        node.right = self.right
        node.right?.left = node
        node.left = self
        self.right = node
        return node
    }

    func removeLeftRight() {
        left?.right = right
        right?.left = left
    }

    func reinsertLeftRight() {
        left?.right = self
        right?.left = self
    }

    func removeTopBottom() {
        top?.bottom = bottom
        bottom?.top = top
    }

    func reinsertTopBottom() {
        top?.bottom = self
        bottom?.top = self
    }
}
