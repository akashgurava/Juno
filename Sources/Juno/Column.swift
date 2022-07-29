/// Column in a table.
public struct Column: Equatable {
    /// Name of column.
    public let name: String
    /// Column datatype.
    public let dtype: DataType.Type

    /// Create new Column from name and datatype.
    /// - Parameters:
    ///   - name: Column name.
    ///   - dtype: Column datatype.
    public init(name: String, dtype: DataType.Type) {
        self.name = name
        self.dtype = dtype
    }

    /// Create new column from name and column value.
    /// - Parameters:
    ///   - name: Column name.
    ///   - value: Column value.
    public init(name: String, value: DataType) {
        self.name = name
        self.dtype = type(of: value)
    }

    /// Check equality.
    /// - Parameters:
    ///   - lhs: Left side value.
    ///   - rhs: Right side value.
    /// - Returns: true if both name and dtype are same.
    public static func == (lhs: Column, rhs: Column) -> Bool {
        (lhs.name == rhs.name) && (lhs.dtype == rhs.dtype)
    }
}
