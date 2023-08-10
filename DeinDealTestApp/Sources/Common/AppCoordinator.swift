import UIKit

final class AppCoordinator: Coordinator<UIWindow> {
    
    override init(rootView: UIWindow) {
        super.init(rootView: rootView)
    }
    
    override func start() {
        setupLaunch()
    }
    
    func setupLaunch() {
        let customTabBarController = TabBarController()
        let mainCoordinator = TabBarControllerCoordinator(rootView: customTabBarController)
        mainCoordinator.start()

        rootView.rootViewController = mainCoordinator.rootView
    }
}
