import Foundation
import Combine
@testable import DeinDealTestApp

final class MockCityServices: CityServicesDelegate {
    
    var shouldReturnError: Bool = false
    var citiesResponse: CitiesResponse!
    
    // Populating with your provided mock data for city 'geneva'
    var mockCityData: [String: CityData] = [
        "geneva": CityData(
            id: "geneva",
            name: "Genève",
            items: [
                CityItem(
                    id: 90564,
                    title: "La Vie Saine",
                    subtitle: "Salades, Jus & Bowls frais",
                    images: Image(cover: "https://soyouz2.deindeal.ch/api/img?p=sales/2023/6/4712C570-BC1A-418C-A192-EACB908E4BC5/109780-VENTE_IMG_MOBILE_DD&v=1689250234"),
                    myThemes: ["fd_healthy"]
                ),
                CityItem(
                    id: 90565,
                    title: "Pizzeria Du Lac",
                    subtitle: "Pizza & Pasta au bord du Léman",
                    images: Image(cover: "https://soyouz2.deindeal.ch/api/img?p=sales/2023/6/33D37CBC-F695-4B19-8468-A9B7D7F57EA9/109366-VENTE_IMG_MOBILE_DD&v=1687768747"),
                    myThemes: ["fd_pizza"]
                ),
            ],
            facetCategories: [
                FacetCategory(
                    id: "fd_healthy",
                    label: "Healthy",
                    icon: "https://galaxy.deindeal.ch/api/img?p=next/themes/fd_healthy.svg&v=1601035845",
                    count: 1
                ),
                FacetCategory(
                    id: "fd_pizza",
                    label: "Pizza",
                    icon: "https://galaxy.deindeal.ch/api/img?p=next/themes/fd_pizza.svg&v=1600854483",
                    count: 1
                ),
            ]
        )
    ]

    func fetchCitiesFromAPI() async throws -> CitiesResponse {
        if shouldReturnError {
            throw CityServices.NetworkError.failedToFetchData
        }
        return citiesResponse
    }
    
    func fetchCityInfo(cityId: String) async throws -> CityData {
        if shouldReturnError {
            throw CityServices.NetworkError.failedToFetchData
        }
        
        guard let cityData = mockCityData[cityId] else {
            throw CityServices.NetworkError.dataUnavailable
        }
        
        return cityData
    }
}

