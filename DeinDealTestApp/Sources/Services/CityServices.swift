import Foundation

public protocol CityServicesDelegate: AnyObject {
    func fetchCitiesFromAPI() async throws -> CitiesResponse
    func fetchCityInfo(cityId: String) async throws -> CityData
}

public class CityServices: CityServicesDelegate {
    
    enum NetworkError: Error {
        case failedToFetchData
        case invalidURL
        case dataUnavailable
        case serverError
        case decodingError
        case notOKStatus(statusCode: Int)
    }
    
    private let baseURL = "https://dev-9r45b2epb810w4g.api.raw-labs.com/cities"
    
    public func fetchCitiesFromAPI() async throws -> CitiesResponse {
        guard let url = URL(string: baseURL) else {
            throw NetworkError.invalidURL
        }
        
        let data = try await fetchData(from: url)
        return try decode(data: data, to: CitiesResponse.self)
    }
    
    public func fetchCityInfo(cityId: String) async throws -> CityData {
        let url = try constructURL(forCityId: cityId)
        let data = try await fetchData(from: url)
        return try decode(data: data, to: CityData.self)
    }
    
    private func constructURL(forCityId cityId: String) throws -> URL {
        var components = URLComponents(string: baseURL)
        components?.path.append("/\(cityId)")
        
        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }
        
        return url
    }
    
    private func fetchData(from url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.serverError
        }
        
        if httpResponse.statusCode != 200 {
            throw NetworkError.notOKStatus(statusCode: httpResponse.statusCode)
        }
        
        return data
    }
    
    private func decode<T: Decodable>(data: Data, to type: T.Type) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
}
