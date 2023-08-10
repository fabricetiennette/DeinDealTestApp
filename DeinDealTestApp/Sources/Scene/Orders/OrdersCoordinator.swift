import UIKit

public final class OrdersCoordinator: Coordinator<UINavigationController> {
    
    unowned var parentCoordinator: TabBarControllerCoordinator?
    weak var delegate: CoordinatorDelegate?
    
    init(rootView: UINavigationController, parentCoordinator: TabBarControllerCoordinator?, delegate: CoordinatorDelegate?) {
        super.init(rootView: rootView)
        self.parentCoordinator = parentCoordinator
        self.delegate = delegate
    }
    
    override public func start() {
        let module = OrdersModule(delegate: self)
        
        rootView.pushViewController(module.viewController, animated: false)
    }
    
}

extension OrdersCoordinator: OrdersModule.Delegate {
    func didFinish(ordersController: OrdersControllerEvent) {
        switch ordersController {
        case .ordersViewModel(let event):
            switch event {
            default:
                break
            }
        }
    }
}
