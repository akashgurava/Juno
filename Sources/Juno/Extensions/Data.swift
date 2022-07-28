import Foundation

extension Data {
    /// Create Data from local path string.
    /// - Parameter path:
    public init(path: String) throws {
        try self.init(contentsOf: URL(fileURLWithPath: path))
    }
}
