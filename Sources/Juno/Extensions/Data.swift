import Foundation

extension Data {
    /// Create Data from local path string.
    /// - Parameter path:
    public init(path: String) throws {
        try self.init(contentsOf: URL(fileURLWithPath: path))
    }

    /// Write to a pth string.
    /// - Parameter path:
    public func write(to path: String) throws {
        try write(to: URL(fileURLWithPath: path))
    }
}
