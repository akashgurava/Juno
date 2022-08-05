import Juno
import XCTest

/// Tests for Juno package.
internal final class JunoTests: XCTestCase {
    /// Test example.
    func testSwiftBridge() throws {
        XCTAssertEqual(hello_rust().toString(), "Hello from Rust!")
    }
}
