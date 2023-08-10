import Foundation

enum AccountControllerEvent {
    case accountViewModel(AccountViewModel.Event)
}

protocol AccountInputBinding {
}

protocol AccountOutputBinding {
}

protocol AccountViewModelDelegate: AnyObject {
    func didFinish(accountController: AccountControllerEvent)
}

final class AccountModule {
    typealias ViewModel = AccountInputBinding & AccountOutputBinding
    typealias Delegate = AccountViewModelDelegate

    private weak var delegate: Delegate?

    var viewController: AccountViewController {
        let viewModel = AccountViewModel()
        viewModel.delegate = delegate
        return AccountViewController(viewModel: viewModel)
    }

    init(delegate: Delegate?) {
        self.delegate = delegate
    }
}
