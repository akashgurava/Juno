import JSON

/// Json Storage.
public struct JsonStore: Store {
    /// Path of Json store.
    private let path: String

    /// Create new JsonStore at path.
    /// - Parameter path: Location of store.
    public init(path: String) {
        self.path = path
    }

    /// Store object.
    /// - Parameter object:
    public func store<T: Table>(object: T) throws {
        let file = File(path: path)
        let data: [UInt8] = try file.read()
        let decoder: [JSON] = try Grammar.parse(data, as: JSON.Rule<Int>.Array.self)
        var objects = try decoder.map { decoder in
            try T(from: decoder)
        }
        objects.append(object)
    }
}
