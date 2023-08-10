import UIKit

public protocol CoordinatorType: AnyObject {
    func start()
}

public protocol CoordinatorDelegate: AnyObject {
    func finish(from coordinator: CoordinatorType?)
}

open class Coordinator<RootView>: CoordinatorType {
    private var childrens: [CoordinatorType]
    public var rootView: RootView

    public init(rootView: RootView) {
        childrens = []
        self.rootView = rootView
    }

    public func add(children: CoordinatorType?) {
        guard let children = children else {
            return
        }

        childrens.append(children)
    }

    open func start() {}
}

extension Coordinator: CoordinatorDelegate {
    public func finish(from coordinator: CoordinatorType?) {
        for (index, children) in childrens.enumerated() where coordinator === children {
            childrens.remove(at: index)
            break
        }
    }
}
