@_exported import JunoRust

/// A 2D structure.
public protocol Table: Codable {}

extension Table {
    /// Get table schema.
    public var schema: Schema {
        let mirror = Mirror(reflecting: self)
        let columns: [Column] = mirror.children.compactMap { prop in
            guard let label = prop.label else {
                return nil
            }
            guard let type = prop.value as? DataType else {
                return nil
            }
            return Column(name: label, value: type)
        }
        return Schema(columns)
    }
}
