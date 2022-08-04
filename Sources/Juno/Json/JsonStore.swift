//import Foundation
//
///// Json Storage.
//public struct JsonStore<T: Codable>: Store {
//    /// Path of Json store.
//    private let path: String
//    private let decoder = JSONDecoder()
//    private let encoder = JSONEncoder()
//
//    /// Create new JsonStore at path.
//    /// - Parameter path: Location of store.
//    public init(path: String) {
//        self.path = path
//    }
//
//    /// Read file at `self.path`.
//    /// - Returns: Array of objects.
//    public func read() throws -> [T] {
//        let data = try Data(path: path)
//        return try decoder.decode([T].self, from: data)
//    }
//
//    /// Write to file at `self.path`.
//    /// - Returns: Array of objects.
//    public func write(_ objects: [T]) throws {
//        let data = try objects.toJSONData(encoder)
//        try data.write(to: path)
//    }
//}
