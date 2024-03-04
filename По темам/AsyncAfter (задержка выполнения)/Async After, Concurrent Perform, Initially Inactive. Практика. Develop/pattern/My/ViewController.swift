import UIKit

class ViewController: UIViewController {
    
    private let myView = MyView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        myView.viewController = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view = myView
    }
}
