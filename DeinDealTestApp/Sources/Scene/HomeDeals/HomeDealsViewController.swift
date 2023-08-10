import UIKit

final class HomeDealsViewController: AppViewController<HomeDealsModule.ViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("HomeDealsViewController")
        view.backgroundColor = .red
    }
}
