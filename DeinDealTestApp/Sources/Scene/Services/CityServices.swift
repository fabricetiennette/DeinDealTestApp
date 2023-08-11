import Foundation

public protocol CityServicesDelegate: AnyObject {
    func fetchCitiesFromAPI() async throws -> CitiesResponse
}

public class CityServices: CityServicesDelegate {
    
    enum NetworkError: Error {
        case failedToFetchData
    }

    public func fetchCitiesFromAPI() async throws -> CitiesResponse {
        let url = URL(string: "https://dev-9r45b2epb810w4g.api.raw-labs.com/cities")!
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.failedToFetchData
        }
        
        return try JSONDecoder().decode(CitiesResponse.self, from: data)
    }
}
