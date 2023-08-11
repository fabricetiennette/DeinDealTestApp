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
        
        // Customize the navigation bar appearance
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .white
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(named: "main") ?? .magenta]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "main") ?? .magenta]
        rootView.navigationBar.prefersLargeTitles = true
        rootView.navigationBar.tintColor = .white
        
        rootView.navigationBar.standardAppearance = navBarAppearance
        rootView.navigationBar.scrollEdgeAppearance = navBarAppearance
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
