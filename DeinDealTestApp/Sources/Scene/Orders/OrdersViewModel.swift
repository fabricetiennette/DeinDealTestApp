import Foundation

final class OrdersViewModel: OrdersModule.ViewModel {
    weak var delegate: OrdersModule.Delegate?
    
    init(delegate: OrdersModule.Delegate?) {
        self.delegate = delegate
    }
}

extension OrdersViewModel {
    enum Event {}
}
