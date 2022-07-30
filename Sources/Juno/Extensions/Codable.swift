import Foundation

extension Encodable {
    func toJSONData(_ encoder: JSONEncoder) throws -> Data {
        try encoder.encode(self)
    }
}
