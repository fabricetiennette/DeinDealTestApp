import UIKit

final class TabBarControllerCoordinator: Coordinator<UITabBarController> {
    
    unowned var parentCoordinator: AppCoordinator?
    weak var delegate: CoordinatorDelegate?
    
    private lazy var homeDealsNavController = createNavController(title: "DeinDeal",
                                                                  imageName: "home_tab_logo",
                                                                  selectedImageName: "home_tab_logo")
    
    private lazy var ordersNavController = createNavController(title: "Commandes",
                                                               systemImageName: "infinity.circle.fill")
    
    private lazy var accountNavController = createNavController(title: "Compte",
                                                                systemImageName: "person")
    
    override func start() {
        let homeDealsCoordinator = HomeDealsCoordinator(rootView: homeDealsNavController, parentCoordinator: self, delegate: self)
        homeDealsCoordinator.start()
        add(children: homeDealsCoordinator)
        
        let ordersCoordinator = OrdersCoordinator(rootView: ordersNavController, parentCoordinator: self, delegate: self)
        ordersCoordinator.start()
        add(children: ordersCoordinator)
        
        let accountCoordinator = AccountCoordinator(rootView: accountNavController, parentCoordinator: self, delegate: self)
        accountCoordinator.start()
        add(children: accountCoordinator)
        
        rootView.viewControllers = [homeDealsNavController, ordersNavController, accountNavController]
        
    }
    
    private func createNavController(title: String,
                                     imageName: String? = nil,
                                     selectedImageName: String? = nil,
                                     systemImageName: String? = nil) -> UINavigationController {
        let navController = UINavigationController()
        if let imageName = imageName {
            navController.tabBarItem = UITabBarItem(title: title,
                                                    image: UIImage(named: imageName),
                                                    selectedImage: UIImage(named: selectedImageName ?? imageName))
        } else if let systemImageName = systemImageName {
            navController.tabBarItem = UITabBarItem(title: title,
                                                    image: UIImage(systemName: systemImageName),
                                                    selectedImage: UIImage(systemName: systemImageName))
        }
        return navController
    }
}
