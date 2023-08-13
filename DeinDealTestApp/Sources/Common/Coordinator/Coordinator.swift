import UIKit

public protocol CoordinatorType: AnyObject {
    func start()
}

public protocol CoordinatorDelegate: AnyObject {
    func finish(from coordinator: CoordinatorType?)
}

/// A base class for Coordinators, designed to manage the application's navigation flow.
open class Coordinator<RootView>: CoordinatorType {
    private var childrens: [CoordinatorType]
    public var rootView: RootView

    public init(rootView: RootView) {
        childrens = []
        self.rootView = rootView
    }

    /// Adds a child coordinator to the parent coordinator.
    public func add(children: CoordinatorType?) {
        guard let children = children else {
            return
        }

        childrens.append(children)
    }

    /// Starts the coordinator's primary action. Intended to be overridden by subclasses.
    open func start() {}
}

extension Coordinator: CoordinatorDelegate {
    /// Removes a coordinator from the children set once it has finished its task.
    public func finish(from coordinator: CoordinatorType?) {
        for (index, children) in childrens.enumerated() where coordinator === children {
            childrens.remove(at: index)
            break
        }
    }
}
