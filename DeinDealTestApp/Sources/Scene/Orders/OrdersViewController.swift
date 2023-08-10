import UIKit

final class OrdersViewController: AppViewController<OrdersModule.ViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("OrdersViewController")
        view.backgroundColor = .blue
    }
}
