import Foundation

final class AccountViewModel: AccountModule.ViewModel {
    weak var delegate: AccountModule.Delegate?

}

extension AccountViewModel {
    enum Event {
        
    }
}
