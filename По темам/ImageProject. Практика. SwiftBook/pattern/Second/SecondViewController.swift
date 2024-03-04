import UIKit

class SecondViewController: UIViewController {

    private let secondView = SecondView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        secondView.secondViewController = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view = secondView
    }

}
