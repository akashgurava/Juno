import Juno
import XCTest

class SfCity: Table {
    let type: String

    init(type: String) {
        self.type = type
    }
}

/// Test JSON Functionality.
public class JsonTests: XCTestCase {
    /// Test reading JSON file.
    func testReadJson() throws {
        let store = JsonStore(path: kSmallFile)
        XCTAssertNoThrow(try store.readAll())
    }
}
