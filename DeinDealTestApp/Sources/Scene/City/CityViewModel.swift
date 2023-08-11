import Foundation
import Combine

public final class CityViewModel: CityModule.ViewModel {
    
    // MARK: - Public Properties
    public var city: City
    public var citiesAvailable: [City]
    public var cityData: AnyPublisher<CityData, Never> {
        return citySubject.eraseToAnyPublisher()
    }
    public var filteredItemsPublisher: Published<[CityItem]>.Publisher { $filteredItems }
    weak var delegate: CityModule.Delegate?
    
    // MARK: - Private Properties
    @Published private var filteredItems: [CityItem] = []
    private var lastFetchedCity: CityData?
    private let citySubject = PassthroughSubject<CityData, Never>()
    private var cancellables: Set<AnyCancellable> = []
    private var cityService: CityServicesDelegate

    // MARK: - Initializer
    public init(city: City, citiesAvailable: [City], cityService: CityServicesDelegate, delegate: CityModule.Delegate?) {
        self.city = city
        self.citiesAvailable = citiesAvailable
        self.cityService = cityService
        self.delegate = delegate
        
        fetchCity(with: city.id)
    }
    
    // MARK: - Public Methods
    public func fetchCity(with id: String) {
        Task {
            do {
                let result = try await cityService.fetchCityInfo(cityId: id)
                self.lastFetchedCity = result
                citySubject.send(result)
            } catch {
                // Better error handling can be implemented here.
                print("Failed to fetch cities with error: \(error)")
            }
        }
    }
    
    public func didSelectCategory(with id: String) {
        guard let lastFetchedCity = lastFetchedCity else { return }
        filteredItems = id == "all" ? lastFetchedCity.items : lastFetchedCity.items.filter { $0.myThemes.contains(id) }
    }
}

extension CityViewModel {
    public enum Event {}
}
