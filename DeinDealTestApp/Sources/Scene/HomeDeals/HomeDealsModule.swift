import Foundation
import Combine

enum HomeDealsControllerEvent {
    case homeDealsViewModel(HomeDealsViewModel.Event)
}

protocol HomeDealsInputBinding {
}

protocol HomeDealsOutputBinding {
    var cities: AnyPublisher<[City], Never> { get }
    
    func fetchCities()
}

protocol HomeDealsViewModelDelegate: AnyObject {
    func didFinish(homeDealsController: HomeDealsControllerEvent)
}

final class HomeDealsModule {
    typealias ViewModel = HomeDealsInputBinding & HomeDealsOutputBinding
    typealias Delegate = HomeDealsViewModelDelegate

    private weak var delegate: Delegate?

    var viewController: HomeDealsViewController {
        let cityServices = CityServices()
        let viewModel = HomeDealsViewModel(cityService: cityServices)
        viewModel.delegate = delegate
        return HomeDealsViewController(viewModel: viewModel)
    }

    init(delegate: Delegate?) {
        self.delegate = delegate
    }
}
