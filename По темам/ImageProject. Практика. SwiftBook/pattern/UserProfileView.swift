import UIKit

// MARK: - UserProfileViewProtocol
protocol UserProfileViewProtocol: UIView {
}

class MyView: UIView, UserProfileViewProtocol {

    init() {
        super.init(frame: .zero)
        setupUserProfileView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension MyView {
    
    func setupUserProfileView() {
        backgroundColor = UIColor(ciColor: .cyan)
    }
    
}
