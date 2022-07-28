import Foundation

/// Json Storage.
public struct JsonStore: Store {
    /// Path of Json store.
    private let path: String
    private let decoder = JSONDecoder()

    /// Create new JsonStore at path.
    /// - Parameter path: Location of store.
    public init(path: String) {
        self.path = path
    }

    /// Store object.
    /// - Parameter object:
    public func store<T: Table>(object: T) throws {
        let data = try Data(path: path)
        var objects = try decoder.decode([T].self, from: data)
        objects.append(object)
    }
}
