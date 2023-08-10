import UIKit

final class HomeDealsCoordinator: Coordinator<UINavigationController> {
    
    unowned var parentCoordinator: TabBarControllerCoordinator?
    weak var delegate: CoordinatorDelegate?
    
    init(rootView: UINavigationController, parentCoordinator: TabBarControllerCoordinator?, delegate: CoordinatorDelegate?) {
        super.init(rootView: rootView)
        self.parentCoordinator = parentCoordinator
        self.delegate = delegate
    }
    
    override func start() {
        let module = HomeDealsModule(delegate: self)
        
        rootView.pushViewController(module.viewController, animated: false)
    }
    
}

extension HomeDealsCoordinator: HomeDealsModule.Delegate {
    func didFinish(homeDealsController: HomeDealsControllerEvent) {
        switch homeDealsController {
        case .homeDealsViewModel(let event):
            switch event {
            default:
                break
            }
        }
    }
}
