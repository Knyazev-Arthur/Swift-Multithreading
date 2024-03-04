import UIKit

// MARK: - UserProfileViewProtocol
protocol MyViewProtocol: UIView {
    var viewController: ViewController? { get set }
}

class MyView: UIView, MyViewProtocol {
    
    weak var viewController: ViewController?    
    private let button = UIButton()
    
    init() {
        super.init(frame: .zero)
        setupMyView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension MyView {
    
    func setupMyView() {
//        afterBlock(seconds: 4, gueue: .global()) {
//            print("Hello")
//            print(Thread.current) // current свойство, содержащее данные о текущем потоке
//        }
        
//        afterBlock(seconds: 2, gueue: .main) {
//            print("Hello")
//            self.showAlert()
//            print(Thread.current)
//        }
        
        backgroundColor = UIColor(ciColor: .cyan)
        setupButton()
        addSubview(button)
        setupButtonConstraints()
    }
    
    func setupButton() {
        button.setTitle("Press", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .green
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    }
    
    @objc func tapButton() {
        viewController?.navigationController?.pushViewController(SecondViewController(), animated: true)
    }
    
    func setupButtonConstraints() {
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let centerX = button.centerXAnchor.constraint(equalTo: centerXAnchor)
        let centerY = button.centerYAnchor.constraint(equalTo: centerYAnchor)
        let width = button.widthAnchor.constraint(equalToConstant: 100)
        
        NSLayoutConstraint.activate([centerX, centerY, width])
    }
    
    func afterBlock(seconds: Int, gueue: DispatchQueue = .global(), complition: @escaping () -> ()) {
        gueue.asyncAfter(deadline: .now() + .seconds(seconds)) {
            complition()
        }
    }
    
    func showAlert() {
        let allertController = UIAlertController(title: nil, message: "Hello", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        allertController.addAction(okAction)
        viewController?.present(allertController, animated: true, completion: nil)
    }
    
}
