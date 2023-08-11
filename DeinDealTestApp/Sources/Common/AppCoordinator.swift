import UIKit
import SDWebImage
import SDWebImageSVGCoder

final class AppCoordinator: Coordinator<UIWindow> {
    
    override init(rootView: UIWindow) {
        super.init(rootView: rootView)
    }
    
    override func start() {
        setupLaunch()
        registerCoder()
    }
    
    func setupLaunch() {
        let customTabBarController = TabBarController()
        let mainCoordinator = TabBarControllerCoordinator(rootView: customTabBarController)
        mainCoordinator.parentCoordinator = self
        mainCoordinator.delegate = self
        add(children: mainCoordinator)
        mainCoordinator.start()

        rootView.rootViewController = mainCoordinator.rootView
    }
    
    private func registerCoder() {
        let SVGCoder = SDImageSVGCoder.shared
        SDImageCodersManager.shared.addCoder(SVGCoder)
    }
}
