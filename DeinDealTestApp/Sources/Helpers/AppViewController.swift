import UIKit

public protocol AppViewControllerProtocol {
    associatedtype ViewModelGenericType

    init(viewModel: ViewModelGenericType)
}

open class AppViewController<U>: UIViewController, AppViewControllerProtocol {
    public typealias ViewModelGenericType = U
    public var viewModel: ViewModelGenericType

    convenience init() {
        fatalError("init() has not been implemented")
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public required init(viewModel: ViewModelGenericType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
}
