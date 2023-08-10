import UIKit

final class AccountViewController: AppViewController<AccountModule.ViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("AccountViewController")
        view.backgroundColor = .yellow
    }
}
