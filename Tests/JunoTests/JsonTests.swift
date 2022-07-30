import Juno
import XCTest

/// Test JSON Functionality.
public class JsonTests: XCTestCase {
    /// Test reading JSON file.
    func testReadJson() throws {
        let store = JsonStore<SfCityLot>(path: kSmallFile)
        XCTAssertNoThrow(try store.read())

        timeit(label: "JSON_STORE_READ_SMALL_FILE") {
            let store = JsonStore<SfCityLot>(path: kSmallFile)
            _ = try store.read()
        }
    }

    /// Test reading JSON file.
    func testWriteJson() throws {
        let readStore = JsonStore<SfCityLot>(path: kSmallFile)
        let data = try readStore.read()

        let store = JsonStore<SfCityLot>(path: kSmallFileGen)
        XCTAssertNoThrow(try store.write(data))

        timeit(label: "JSON_STORE_WRITE_SMALL_FILE") {
            let store = JsonStore<SfCityLot>(path: kSmallFileGen)
            try store.write(data)
        }
    }
}
