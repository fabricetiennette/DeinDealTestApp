import UIKit
import SDWebImage
import SDWebImageSVGCoder

final class AppCoordinator: Coordinator<UIWindow> {
    
    // MARK: - Initialization
    
    override init(rootView: UIWindow) {
        super.init(rootView: rootView)
    }
    
    // MARK: - Coordinator Lifecycle
    
    override func start() {
        setupLaunch()
        registerImageCoders()
    }
    
    // MARK: - Setup Methods
    
    /// Sets up the initial launch view controller.
    private func setupLaunch() {
        let customTabBarController = TabBarController()
        let mainCoordinator = TabBarControllerCoordinator(rootView: customTabBarController)
        
        mainCoordinator.parentCoordinator = self
        mainCoordinator.delegate = self
        add(children: mainCoordinator)
        mainCoordinator.start()
        
        rootView.rootViewController = mainCoordinator.rootView
    }
    
    /// Registers necessary image coders.
    private func registerImageCoders() {
        SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
    }
}
