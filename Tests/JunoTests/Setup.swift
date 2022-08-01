import Foundation
import Juno

/// Small file path
internal let kSmallFile = "/Users/akash/citylots-small.json"
internal let kSmallFileGen = "/Users/akash/citylots-small-gen.json"

/// Small file path
internal let kMidFile = "/Users/akash/citylots-mid.json"
internal let kMidFileGen = "/Users/akash/citylots-mid-gen.json"

// MARK: - SfCityLot
struct SfCityLot: Table {
    let type: SfCityLotType
    let properties: Properties
    let geometry: Geometry?

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case properties = "properties"
        case geometry = "geometry"
    }
}

// MARK: - Geometry
struct Geometry: Table {
    let type: GeometryType
    let coordinates: [[[Coordinate]]]

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case coordinates = "coordinates"
    }
}

enum Coordinate: Table {
    case double(Double)
    case doubleArray([Double])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([Double].self) {
            self = .doubleArray(x)
            return
        }
        if let x = try? container.decode(Double.self) {
            self = .double(x)
            return
        }
        throw DecodingError.typeMismatch(
            Coordinate.self,
            DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Wrong type for Coordinate"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .double(let x):
            try container.encode(x)
        case .doubleArray(let x):
            try container.encode(x)
        }
    }
}

enum GeometryType: String, Table {
    case multiPolygon = "MultiPolygon"
    case polygon = "Polygon"
}

// MARK: - Properties
struct Properties: Table {
    let mapblklot: String
    let blklot: String
    let blockNum: String
    let lotNum: String
    let fromSt: String?
    let toSt: String?
    let street: String?
    let oddEven: OddEven?

    enum CodingKeys: String, CodingKey {
        case mapblklot = "MAPBLKLOT"
        case blklot = "BLKLOT"
        case blockNum = "BLOCK_NUM"
        case lotNum = "LOT_NUM"
        case fromSt = "FROM_ST"
        case toSt = "TO_ST"
        case street = "STREET"
        case oddEven = "ODD_EVEN"
    }
}

enum OddEven: String, Table {
    case even = "E"
    case odd = "O"
}

enum SfCityLotType: String, Table {
    case feature = "Feature"
}

typealias SfCityLots = [SfCityLot]
