import UIKit

class ViewController: UIViewController {
    
    private let userProfileView: UserProfileView
    
    init() {
        userProfileView = UserProfileView()
        super.init(nibName: nil, bundle: nil)
        view.addSubview(userProfileView)
        view.backgroundColor = .white
        setupUserProfileViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUserProfileViewConstraints() {
        userProfileView.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = userProfileView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        let trailing = userProfileView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        let top = userProfileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let bottom = userProfileView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }

}
