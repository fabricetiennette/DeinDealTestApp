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
        rootView.navigationBar.tintColor = UIColor(named: "main")
        
        rootView.navigationBar.standardAppearance = navBarAppearance
        rootView.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    final func navigateToController(_ controller: UIViewController) {
        rootView.pushViewController(controller, animated: true)
    }
}

extension HomeDealsCoordinator: HomeDealsModule.Delegate {
    func didFinish(homeDealsController: HomeDealsControllerEvent) {
        var controller: UIViewController
        switch homeDealsController {
        case .homeDealsViewModel(let event):
            switch event {
            case let .city(city, citiesAvailable):
                let module = CityModule(city: city, citiesAvailable: citiesAvailable, delegate: self)
                controller = module.viewController

            }
            navigateToController(controller)
        }
    }
}

extension HomeDealsCoordinator: CityModule.Delegate {
    func didFinish(cityController: CityControllerEvent) {
        switch cityController {
        case .cityViewModel(let event):
            switch event {
            default: break
            }
        }
    }
    
    
}
