import Juno
import XCTest

/// Test JSON Functionality.
public class JsonTests: XCTestCase {
    private let smallFile = "/Users/akash/small-file.json"
    private let largeFile = "/Users/akash/large-file.json"

    /// Test JSON Encoding.
    func testEncode() {
        timeit(label: "STRING_READ_SMALL_FILE") {
            try! String(contentsOfFile: smallFile)
        }
    }

    // func testReadJson() throws {
    //     struct Actor: Table {
    //         let id: Int
    //     }
    //     struct Msg: Table {
    //         let id: String
    //         let type: String
    //         let actor: Actor
    //     }
    //     let actor = Actor(id: 22)
    //     let msg = Msg(id: "jik", type: "mks", actor: actor)
    //     let store = JsonStore(path: "/Users/akash/large-file.json")
    //     try store.store(object: msg)
    // }
}
