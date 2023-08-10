import Foundation

enum HomeDealsControllerEvent {
    case homeDealsViewModel(HomeDealsViewModel.Event)
}

protocol HomeDealsInputBinding {
}

protocol HomeDealsOutputBinding {

}

protocol HomeDealsViewModelDelegate: AnyObject {
    func didFinish(homeDealsController: HomeDealsControllerEvent)
}

final class HomeDealsModule {
    typealias ViewModel = HomeDealsInputBinding & HomeDealsOutputBinding
    typealias Delegate = HomeDealsViewModelDelegate

    private weak var delegate: Delegate?

    var viewController: HomeDealsViewController {
        let viewModel = HomeDealsViewModel()
        viewModel.delegate = delegate
        return HomeDealsViewController(viewModel: viewModel)
    }

    init(delegate: Delegate?) {
        self.delegate = delegate
    }
}
