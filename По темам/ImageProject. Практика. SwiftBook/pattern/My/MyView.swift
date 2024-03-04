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
        backgroundColor = UIColor(ciColor: .cyan)
        setupButton()
        addSubview(button)
        setupButtonConstraints()
    }
    
    func setupButton() {
        button.setTitle("Go to 2 VC", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    }
    
    @objc func tapButton() {
        viewController?.navigationController?.pushViewController(SecondViewController(), animated: true)
    }
    
    func setupButtonConstraints() {
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let centerX = button.centerXAnchor.constraint(equalTo: centerXAnchor)
        let centerY = button.centerYAnchor.constraint(equalTo: centerYAnchor)
        
        NSLayoutConstraint.activate([centerX, centerY])
    }
    
}
