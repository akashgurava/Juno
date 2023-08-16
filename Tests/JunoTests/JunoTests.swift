import Juno
import XCTest

/// Tests for Juno package.
internal final class JunoTests: XCTestCase {
    /// Test example.
    func testSwiftBridge() throws {
        timeit(label: "EMPTY_DATA", loops: 1000, iterations: 1000) {
           let x =  make_data()
            _ = x.id; _ = x.name;
        }
    }
}
