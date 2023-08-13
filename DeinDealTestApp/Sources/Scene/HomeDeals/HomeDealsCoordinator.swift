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
        let cityServices = CityServices()
        let module = HomeDealsModule(cityService: cityServices, delegate: self)
        rootView.pushViewController(module.viewController, animated: false)
        configureNavigationBarAppearance()
    }
    
    private func configureNavigationBarAppearance() {
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

// MARK: - HomeDealsModule Delegate

extension HomeDealsCoordinator: HomeDealsModule.Delegate {
    func didFinish(homeDealsController: HomeDealsControllerEvent) {
        var controller: UIViewController
        switch homeDealsController {
        case .homeDealsViewModel(let event):
            switch event {
            case let .city((city, citiesAvailable)):
                let cityService = CityServices()
                let module = CityModule(city: city,
                                        citiesAvailable: citiesAvailable,
                                        cityService: cityService,
                                        delegate: self)
                controller = module.viewController

            }
            navigateToController(controller)
        }
    }
}

// MARK: - CityModule Delegate

extension HomeDealsCoordinator: CityModule.Delegate {
    func didFinish(cityController: CityControllerEvent) {}
}
