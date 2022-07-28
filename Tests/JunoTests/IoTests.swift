import Foundation
import Juno
import XCTest

public class IoTests: XCTestCase {
    let path = "/Users/akash/large-file.json"

    /// Lets validate that Raw read using File data is same as Foundation's Data.
    func testValidateRaw() throws {
        let file = File(path: self.path)
        let bytes: [UInt8] = try file.readAsBytes()
        let dataRaw: Data = Data(bytes)

        let dataContentsOf: Data = try Data(
            contentsOf: .init(fileURLWithPath: self.path)
        )
        XCTAssertEqual(dataRaw, dataContentsOf)
    }

    func testIoDataPerformance() throws {
        timeit(label: "DATA_RAW_READ", loops: 10) {
            let file = File(path: self.path)
            let bytes: [UInt8] = try! file.readAsBytes()
            let _: Data = Data(bytes)
        }

        timeit(label: "DATA_CONTENTS_OF", loops: 10) {
            let _: Data = try! Data(contentsOf: .init(fileURLWithPath: self.path))
        }
    }

    func testJsonDecoder() throws {
        struct Msg: Table {
            let id: String
            let type: String
        }
        let data: Data = try! Data(contentsOf: .init(fileURLWithPath: self.path))
        let decoder = JSONDecoder()
        _ = try decoder.decode([Msg].self, from: data)
    }

    func testIoBytesPerformance() throws {
        timeit(label: "BYTES_RAW_READ") {
            let file = File(path: self.path)
            let _: [UInt8] = try! file.readAsBytes()
        }

        timeit(label: "BYTES_CONTENTS_OF") {
            let rawData = try! Data(contentsOf: .init(fileURLWithPath: self.path))
            let _: [UInt8] = Array(rawData)
        }
    }

    func testIoStringPerformance() throws {
        timeit(label: "STRING_RAW_READ") {
            let file = File(path: self.path)
            let _: String = try! file.readAsString()
        }

        timeit(label: "STRING_CONTENTS_OF") {
            let _: String = try! String(contentsOfFile: self.path)
        }
    }
}
