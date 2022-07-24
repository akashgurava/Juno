import Foundation

/// A protocol all columns must adhere to.
public protocol Column: Codable {}

extension Bool: Column {}

extension Int: Column {}
extension Int8: Column {}
extension Int16: Column {}
extension Int32: Column {}
extension Int64: Column {}

extension UInt: Column {}
extension UInt8: Column {}
extension UInt16: Column {}
extension UInt32: Column {}
extension UInt64: Column {}

extension Float: Column {}
@available(macOS 11.0, *)
extension Float16: Column {}
extension Float64: Column {}

extension String: Column {}

extension Date: Column {}

extension Optional: Column where Wrapped: Column {}

extension Array: Column where Element: Column {}

extension Set: Column where Element: Column {}
