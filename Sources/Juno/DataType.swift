import Foundation

/// A protocol all columns must adhere to.
public protocol DataType: Codable {}

extension Bool: DataType {}

extension Int: DataType {}
extension Int8: DataType {}
extension Int16: DataType {}
extension Int32: DataType {}
extension Int64: DataType {}

extension UInt: DataType {}
extension UInt8: DataType {}
extension UInt16: DataType {}
extension UInt32: DataType {}
extension UInt64: DataType {}

extension Float: DataType {}
@available(macOS 11.0, *)
extension Float16: DataType {}
extension Float64: DataType {}

extension String: DataType {}

extension Date: DataType {}

extension Optional: DataType where Wrapped: DataType {}

extension Array: DataType where Element: DataType {}

extension Set: DataType where Element: DataType {}
