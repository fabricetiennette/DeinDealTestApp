import Combine

public final class HomeDealsViewModel: HomeDealsModule.ViewModel {
    
    // MARK: - Public Properties
    public var cities: AnyPublisher<[City], Never> {
        return citiesSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Private Properties
    private let citiesSubject = PassthroughSubject<[City], Never>()
    private var cityService: CityServicesDelegate
    
    // MARK: - Delegate
    weak var delegate: HomeDealsModule.Delegate?
    
    // MARK: - Initialization
    public init(cityService: CityServicesDelegate, delegate: HomeDealsModule.Delegate?) {
        self.cityService = cityService
        self.delegate = delegate
    }
    
    // MARK: - Public Methods
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
    
    public func didTappedCity(with city: City, cities: [City]) {
        self.delegate?.didFinish(homeDealsController: .homeDealsViewModel(.city((city, cities))))
    }
}

// MARK: - Extensions
extension HomeDealsViewModel {
    public typealias CityEvent = (City, [City])
    public enum Event {
        case city(CityEvent)
    }
}

