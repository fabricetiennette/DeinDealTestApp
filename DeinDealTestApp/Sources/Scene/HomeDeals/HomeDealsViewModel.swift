import Combine
import Foundation

public final class HomeDealsViewModel: HomeDealsModule.ViewModel {
    weak var delegate: HomeDealsModule.Delegate?
    
    public var cities: AnyPublisher<[City], Never> {
        return citiesSubject.eraseToAnyPublisher()
    }
    
    private let citiesSubject = PassthroughSubject<[City], Never>()
    private var cityService: CityServicesDelegate
    
    public init(cityService: CityServicesDelegate, delegate: HomeDealsModule.Delegate?) {
        self.cityService = cityService
        self.delegate = delegate
    }

    public func fetchCities() {
        Task {
            do {
                let result = try await cityService.fetchCitiesFromAPI()
                citiesSubject.send(result.cities)
            } catch {
                print("Failed to fetch cities with error: \(error)")
            }
        }
    }
}

extension HomeDealsViewModel {
    public enum Event {
        
    }
}
