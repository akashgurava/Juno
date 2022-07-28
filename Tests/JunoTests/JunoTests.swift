import Juno
import XCTest

/// Tests for Juno package.
internal final class JunoTests: XCTestCase {
    /// Test example.
    func testExample() throws {
        struct TestTableEmpty: Table {}
        struct TestTable: Table {
            /// Sample string column.
            let name: String
            /// Sample int column.
            let names: Int64
        }

        XCTAssertNoThrow(TestTableEmpty())
        XCTAssertNoThrow(TestTable(name: "JUNO", names: 9))

        let empty = TestTableEmpty()
        let string = TestTable(name: "JUNO", names: 9)

        XCTAssertEqual(empty.schema.columns, [])
        XCTAssertEqual(string.schema.columns, ["name", "names"])
    }

    func testReadJson() throws {
        struct Actor: Table {
            let id: Int
        }
        struct Msg: Table {
            let id: String
            let type: String
            let actor: Actor
        }
        let actor = Actor(id: 22)
        let msg = Msg(id: "jik", type: "mks", actor: actor)
        let store = JsonStore(path: "/Users/akash/large-file.json")
        try store.store(object: msg)
    }
}
