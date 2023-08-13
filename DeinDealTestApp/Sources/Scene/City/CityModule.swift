import Foundation
import Combine

public enum CityControllerEvent {
    case cityViewModel(CityViewModel.Event)
}

public protocol CityInputBinding {
    func fetchCity(with id: String)
    func didSelectCategory(with id: String)
}

public protocol CityOutputBinding {
    var city: City { get }
    var citiesAvailable: [City] { get }
    var cityData: AnyPublisher<CityData, Never> { get }
    var filteredItemsPublisher: Published<[CityItem]>.Publisher { get }
}

public protocol CityViewModelDelegate: AnyObject {
    func didFinish(cityController: CityControllerEvent)
}

public final class CityModule {
    public typealias ViewModel = CityInputBinding & CityOutputBinding
    public typealias Delegate = CityViewModelDelegate

    private weak var delegate: Delegate?
    private var city: City
    private var citiesAvailable: [City]
    private let cityService: CityServicesDelegate

    public var viewController: CityViewController {
        let viewModel = CityViewModel(city: city,
                                      citiesAvailable: citiesAvailable,
                                      cityService: cityService,
                                      delegate: delegate)
        return CityViewController(viewModel: viewModel)
    }

    public init(city: City, citiesAvailable: [City], cityService: CityServicesDelegate, delegate: Delegate?) {
        self.city = city
        self.citiesAvailable = citiesAvailable
        self.cityService = cityService
        self.delegate = delegate
    }
}
