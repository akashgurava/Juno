/// Table schema.
public struct Schema: CustomStringConvertible {
    /// Max characters of Column name to print.
    private let maxColNameLen: Int = 20
    /// Max characters of Column type to print.
    private let maxColTypeLen: Int = 20

    /// Header when printing.
    private var header: String {
        let nameHead = String(repeating: "*", count: maxColNameLen)
        let typeHead = String(repeating: "*", count: maxColTypeLen)
        return "|\(nameHead)|\(typeHead)|"
    }

    /// Custom string representation.
    public var description: String {
        "\(header)\n\(header)"
    }

    /// Columns in this schema.
    public var columns: [Column]

    /// Create from inner schema data.
    /// - Parameter schemaData: Dictionary of Column name to column.
    public init(_ columns: [Column]) {
        self.columns = columns
    }

    /// Create from inner schema data.
    /// - Parameter schemaData: Dictionary of Column name to column.
    public init(_ schema: [(String, DataType)]) {
        self.columns = schema.map { name, dtype in
            Column(name: name, dtype: type(of: dtype))
        }
    }
}
