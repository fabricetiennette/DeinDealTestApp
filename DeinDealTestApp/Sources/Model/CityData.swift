import Foundation

public struct CityData: Codable {
    let id: String
    let name: String
    let items: [CityItem]
    let facetCategories: [FacetCategory]
}

public struct CityItem: Codable, Equatable {
    let id: Int
    let title: String
    let subtitle: String
    let images: Image
    let myThemes: [String]
    
    public static func == (lhs: CityItem, rhs: CityItem) -> Bool {
        return lhs.id == rhs.id
    }
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
