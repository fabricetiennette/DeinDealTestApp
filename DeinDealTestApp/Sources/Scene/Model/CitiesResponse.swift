import Foundation

public struct CitiesResponse: Codable {
    let cities: [City]
}

public struct City: Codable {
    let id: String
    let channelInfo: ChannelInfo
}

public struct ChannelInfo: Codable {
    let title: String
    let images: Images
}

public struct Images: Codable {
    let small: String
    let large: String
}
