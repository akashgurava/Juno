import OrderedCollections

/// A 2D structure.
public protocol Table: Codable {}

extension Table {
    /// Get table schema.
    public var schema: Schema {
        let mirror = Mirror(reflecting: self)
        let columnArray: [(String, Column)] = mirror.children.compactMap { prop in
            guard let label = prop.label else {
                return nil
            }
            guard let type = prop.value as? Column else {
                return nil
            }
            return (label, type)
        }
        let columnDict = OrderedDictionary(uniqueKeysWithValues: columnArray)
        return Schema(columnDict)
    }
}
