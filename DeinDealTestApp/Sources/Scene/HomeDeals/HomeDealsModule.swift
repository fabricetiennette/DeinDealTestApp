import Foundation
import Combine

public enum HomeDealsControllerEvent {
    case homeDealsViewModel(HomeDealsViewModel.Event)
}

public protocol HomeDealsInputBinding {
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

    private weak var delegate: Delegate?

    public var viewController: HomeDealsViewController {
        let cityServices = CityServices()
        let viewModel = HomeDealsViewModel(cityService: cityServices, delegate: delegate)
        return HomeDealsViewController(viewModel: viewModel)
    }

    public init(delegate: Delegate?) {
        self.delegate = delegate
    }
}
