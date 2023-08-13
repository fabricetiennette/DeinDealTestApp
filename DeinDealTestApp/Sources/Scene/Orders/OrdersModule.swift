import Foundation

enum OrdersControllerEvent {
    case ordersViewModel(OrdersViewModel.Event)
}

protocol OrdersInputBinding {}

protocol OrdersOutputBinding {}

protocol OrdersViewModelDelegate: AnyObject {
    func didFinish(ordersController: OrdersControllerEvent)
}

final class OrdersModule {
    typealias ViewModel = OrdersInputBinding & OrdersOutputBinding
    typealias Delegate = OrdersViewModelDelegate

    private weak var delegate: Delegate?

    var viewController: OrdersViewController {
        let viewModel = OrdersViewModel(delegate: delegate)
        return OrdersViewController(viewModel: viewModel)
    }

    init(delegate: Delegate?) {
        self.delegate = delegate
    }
}
