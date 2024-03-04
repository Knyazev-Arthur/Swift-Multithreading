import UIKit

// MARK: - UserProfileViewProtocol
protocol SecondViewProtocol: UIView {
    var secondViewController: SecondViewController? { get set }
}

class SecondView: UIView, SecondViewProtocol {
    
    weak var secondViewController: SecondViewController?
    private let imageView = UIImageView()
    private let activityIndicator = UIActivityIndicatorView()

    init() {
        super.init(frame: .zero)
        setupSecondView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToWindow() {
        delay(3) {
            self.loginALert()
        }
    }
    
}

private extension SecondView {
    
    func setupSecondView() {
        backgroundColor = UIColor(ciColor: .cyan)
        activityIndicator.style = .medium
        setupImageView()
        fetchImage()
        addSubview(imageView)
        addSubview(activityIndicator)
        setupImageViewConstraints()
        setupActivityIndicatorConstraints()
    }
    
    func setupImageView() {
        imageView.backgroundColor = .green
        imageView.contentMode = .scaleAspectFit
    }
    
    func fetchImage() {
        guard let imageURL = URL(string: "https://images.wallpaperscraft.ru/image/single/volkswagen_avtomobil_furgon_1170875_3840x2160.jpg") else { return }
        activityIndicator.startAnimating()
        
        let queue2 = DispatchQueue(label: "DispatchQueueImageLoad", qos: .default, attributes: .concurrent)
        queue2.async { // метод очереди для асинхронного выполнения кода
            guard let data = try? Data(contentsOf: imageURL) else { return }
            
            DispatchQueue.main.async { // переключение на главную очередь и асинхронное выполнение кода на главном потоке
                self.imageView.image = UIImage(data: data)
                self.activityIndicator.stopAnimating()
            }
            
        }
        
    }
    
    func loginALert() {
        let allertController = UIAlertController(title: "Зарегистрирован?", message: "Введите пароль", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: nil)
        allertController.addAction(okAction)
        allertController.addAction(cancelAction)
        allertController.addTextField { userNameTF in
            userNameTF.placeholder = "Введите логин"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        allertController.addTextField { userPasswordTF in
            userPasswordTF.placeholder = "Введите пароль"
            userPasswordTF.isSecureTextEntry = true
        }
        }
        
        secondViewController?.present(allertController, animated: true, completion: nil)
    }
    
    // @escaping перед замыканием указывает компилятору, что это замыкание может быть вызвано после завершения функции, в которой оно было передано. Это необходимо, когда замыкание сохраняется и используется позже, как в вашем случае, когда оно передается в асинхронную функцию asyncAfter.
    // now() - статический метод структуры DispatchTime, возвращающий текущее системное время, представленное в виде объекта DispatchTime
    func delay(_ delay: Int, closure: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
            closure()
        }
    }
    
    func setupImageViewConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        let leading = imageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
        let trailing = imageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        let height = imageView.heightAnchor.constraint(equalToConstant: 400)
        
        NSLayoutConstraint.activate([top, leading, trailing, height])
    }
    
    func setupActivityIndicatorConstraints() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        let centerX = activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor)
        let centerY = activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        
        NSLayoutConstraint.activate([centerX, centerY])
    }
    
}
