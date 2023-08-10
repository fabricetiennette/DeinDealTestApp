import UIKit

public final class TabBarController: UITabBarController {
    
    public var controllers: [UIViewController] = [] {
        didSet {
            viewControllers = controllers
        }
    }

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().backgroundColor = .lightGray
        tabBar.backgroundImage = UIImage()
        UITabBar.appearance().tintColor = UIColor(named: "main")
        UITabBar.appearance().scrollEdgeAppearance = UITabBarAppearance(barAppearance: .init())
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedIndex = 0
    }
}

