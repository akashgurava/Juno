import OrderedCollections

/// Table schema.
public struct Schema: CustomStringConvertible {
    /// Max characters of Column name to print.
    private let maxColNameLen: Int = 20
    /// Max characters of Column type to print.
    private let maxColTypeLen: Int = 20

    /// Inner data.
    private var inner: OrderedDictionary<String, Column>
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

    /// Column names.
    public var columns: [String] {
        Array(inner.keys)
    }

    /// Create from inner schema data.
    /// - Parameter schemaData: Dictionary of Column name to column.
    public init(_ schemaData: OrderedDictionary<String, Column>) {
        self.inner = schemaData
    }
}
