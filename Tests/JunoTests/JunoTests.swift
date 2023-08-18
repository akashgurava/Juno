 import Juno
 import XCTest

class Man: PersonProtocol {
    func greet() {
        <#code#>
    }
    
    func name() -> String {
        ""
    }
}

// private struct TestTable: Table {
//     /// Sample string column.
//     let name: String
//     /// Sample int column.
//     let value: Int64
// }

 /// Tests for Juno package.
 internal final class JunoTests: XCTestCase {
     /// Test example.
     func testExample() throws {
         greet(person: Man())
//         struct TestTableEmpty: Table {}

//         XCTAssertNoThrow(TestTableEmpty())
//         XCTAssertNoThrow(TestTable(name: "JUNO", value: 9))

//         let empty = TestTableEmpty()
//         let string = TestTable(name: "JUNO", value: 9)

//         XCTAssertEqual(empty.schema.columns, [])
//         XCTAssertEqual(
//             string.schema.columns,
//             [
//                 Column(name: "name", dtype: String.self),
//                 Column(name: "Value", dtype: Int64.self),
//             ]
//         )
     }
 }
