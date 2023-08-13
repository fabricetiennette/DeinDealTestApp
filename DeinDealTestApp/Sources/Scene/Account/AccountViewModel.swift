import Foundation

final class AccountViewModel: AccountModule.ViewModel {
    weak var delegate: AccountModule.Delegate?

    init(delegate: AccountModule.Delegate?) {
        self.delegate = delegate
    }
}

extension AccountViewModel {
    enum Event {}
}
