import UIKit

public final class AccountCoordinator: Coordinator<UINavigationController> {
    
    unowned var parentCoordinator: TabBarControllerCoordinator?
    weak var delegate: CoordinatorDelegate?
    
    init(rootView: UINavigationController, parentCoordinator: TabBarControllerCoordinator?, delegate: CoordinatorDelegate?) {
        super.init(rootView: rootView)
        self.parentCoordinator = parentCoordinator
        self.delegate = delegate
    }
    
    override public func start() {
        let module = AccountModule(delegate: self)
        rootView.pushViewController(module.viewController, animated: false)
    }
    
}

extension AccountCoordinator: AccountModule.Delegate {
    func didFinish(accountController: AccountControllerEvent) {
        switch accountController {
        case .accountViewModel(let event):
            switch event {
            default:
                break
            }
        }
    }
}
