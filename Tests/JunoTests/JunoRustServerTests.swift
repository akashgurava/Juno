import Combine
import Juno
import XCTest

/// Verify if a URL is connectable.
/// - Parameter urlPath: path of url
public func verifyURL(urlPath: String) async throws {
    guard let url = URL(string: urlPath) else {
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"

    let (_, _) = try await URLSession.shared.data(from: url)
}

/// Test JunoRustServer Functionality.
public class JsonRustServerTests: XCTestCase {
    override public class func setUp() {
        super.setUp()
        DispatchQueue.global(qos: .background).async {
            startServer()
        }
    }

    override public class func tearDown() {
        stopServer()
        super.tearDown()
    }

    /// Test message send.
    func testMsgSend() async {
        await timeit(label: "ji") {
            try await verifyURL(urlPath: "http://127.0.0.1:3000/")
        }
    }

    /// Test message sends.
    func testMsgSends() {
        print("hi")
    }
}
