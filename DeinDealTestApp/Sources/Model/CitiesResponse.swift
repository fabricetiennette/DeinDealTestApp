import Foundation

public struct CitiesResponse: Codable {
    let cities: [City]
}

public struct City: Codable, Equatable {
    let id: String
    let channelInfo: ChannelInfo

    public static func == (lhs: City, rhs: City) -> Bool {
        return lhs.id == rhs.id
    }
}

public struct ChannelInfo: Codable {
    let title: String
    let images: Images
}

public struct Images: Codable {
    let small: String
    let large: String
}
