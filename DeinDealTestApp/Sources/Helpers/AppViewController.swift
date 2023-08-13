import UIKit

/**
 An abstract `UIViewController` class that requires an associated view model for initialization.
 */
open class AppViewController<U>: UIViewController {

    /// The associated view model for the view controller.
    public var viewModel: U

    /// Default initializer is unavailable. Use `init(viewModel:)` instead.
    convenience init() {
        fatalError("Use `init(viewModel:)` to initialize the view controller.")
    }

    /// Storyboard-based initialization is unavailable. Use `init(viewModel:)` instead.
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboard-based initialization is not supported. Use `init(viewModel:)` instead.")
    }

    /// Initializes the view controller with a view model.
    public required init(viewModel: U) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
}
