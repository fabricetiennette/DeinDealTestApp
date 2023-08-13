import Foundation
import Combine

public enum HomeDealsControllerEvent {
    case homeDealsViewModel(HomeDealsViewModel.Event)
}

public protocol HomeDealsInputBinding {
    func didTappedCity(with city: City, cities: [City])
}

public protocol HomeDealsOutputBinding {
    var cities: AnyPublisher<[City], Never> { get }
    
    func fetchCities()
}

public protocol HomeDealsViewModelDelegate: AnyObject {
    func didFinish(homeDealsController: HomeDealsControllerEvent)
}

public final class HomeDealsModule {
    public typealias ViewModel = HomeDealsInputBinding & HomeDealsOutputBinding
    public typealias Delegate = HomeDealsViewModelDelegate

    weak var delegate: Delegate?
    private let cityService: CityServicesDelegate

    var viewController: HomeDealsViewController {
        let viewModel = HomeDealsViewModel(cityService: cityService, delegate: delegate)
        return HomeDealsViewController(viewModel: viewModel)
    }

    public init(cityService: CityServicesDelegate, delegate: Delegate?) {
        self.cityService = cityService
        self.delegate = delegate
    }
}
