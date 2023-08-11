import Combine
import Foundation

final class HomeDealsViewModel: HomeDealsModule.ViewModel {
    weak var delegate: HomeDealsModule.Delegate?
    
    public var cities: AnyPublisher<[City], Never> {
        return citiesSubject.eraseToAnyPublisher()
    }
    
    private let citiesSubject = PassthroughSubject<[City], Never>()
    private var cityService: CityServicesDelegate
    
    init(cityService: CityServicesDelegate) {
        self.cityService = cityService
    }

    public func fetchCities() {
        Task {
            do {
                let result = try await cityService.fetchCitiesFromAPI()
                citiesSubject.send(result.cities)
            } catch {
            }
        }
    }
}

extension HomeDealsViewModel {
    enum Event {
        
    }
}
