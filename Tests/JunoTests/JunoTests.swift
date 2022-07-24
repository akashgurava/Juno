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
}
