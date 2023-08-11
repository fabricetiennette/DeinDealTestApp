import Foundation

public struct CityData: Codable {
    let id: String
    let name: String
    let items: [CityItem]
    let facetCategories: [FacetCategory]
}

public struct CityItem: Codable {
    let id: Int
    let title: String
    let subtitle: String
    let images: Image
    let myThemes: [String]
}

public struct Image: Codable {
    let cover: String
}

public struct FacetCategory: Codable {
    let id: String
    let label: String
    let icon: String
    let count: Int
}
