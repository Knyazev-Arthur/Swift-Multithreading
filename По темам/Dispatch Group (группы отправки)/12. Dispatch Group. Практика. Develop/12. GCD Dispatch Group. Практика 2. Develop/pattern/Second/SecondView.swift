import UIKit

// MARK: - UserProfileViewProtocol
protocol SecondViewProtocol: UIView {
    var secondViewController: SecondViewController? { get set }
}

class SecondView: UIView, SecondViewProtocol {
    
    weak var secondViewController: SecondViewController?
    private let imageViewOne = UIImageView()
    private let imageViewTwo = UIImageView()
    private let imageViewThree = UIImageView()
    private let imageViewFour = UIImageView()
    private let arrayImage: [UIImageView]
    private let heightImage = UIScreen.main.bounds.height / 4.5
    private var images = [UIImage]()
    private let imageURLs = ["https://kartiny-hudozhnikov.ru/wp-content/uploads/shishkin-i.i.-kartina-utro-v-sosnovom-lesu.jpg", "https://kartiny-hudozhnikov.ru/wp-content/uploads/shishkin-i.i.-kartina-stado-pod-derevyami-1864-god72.4h104.jpg", "https://kartiny-hudozhnikov.ru/wp-content/uploads/shishkin-i.i.-kartina-srublennye-berezy.-1864-god-188h445.jpg", "https://kartiny-hudozhnikov.ru/wp-content/uploads/shishkin-i.i.-kartina-sosnovyy-bor.jpg"]

    init() {
        arrayImage = [imageViewOne, imageViewTwo, imageViewThree, imageViewFour]
        super.init(frame: .zero)
        setupSecondView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension SecondView {
    
    func setupSecondView() {
        backgroundColor = .cyan
        for image in arrayImage { image.contentMode = .scaleToFill }
        addSubview(imageViewOne)
        addSubview(imageViewTwo)
        addSubview(imageViewThree)
        addSubview(imageViewFour)
        setupImageViewOneConstraints()
        setupImageViewTwoConstraints()
        setupImageViewThreeConstraints()
        setupImageViewFourConstraints()
        asyncURLSession()
//        asyncGroup()
    }
    
    func setupImageViewOneConstraints() {
        imageViewOne.translatesAutoresizingMaskIntoConstraints = false
        
        let top = imageViewOne.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        let leading = imageViewOne.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
        let trailing = imageViewOne.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        let height = imageViewOne.heightAnchor.constraint(equalToConstant: heightImage)
        
        NSLayoutConstraint.activate([top, leading, trailing, height])
    }
    
    func setupImageViewTwoConstraints() {
        imageViewTwo.translatesAutoresizingMaskIntoConstraints = false
        
        let top = imageViewTwo.topAnchor.constraint(equalTo: imageViewOne.bottomAnchor)
        let leading = imageViewTwo.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
        let trailing = imageViewTwo.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        let height = imageViewTwo.heightAnchor.constraint(equalToConstant: heightImage)
        
        NSLayoutConstraint.activate([top, leading, trailing, height])
    }
    
    func setupImageViewThreeConstraints() {
        imageViewThree.translatesAutoresizingMaskIntoConstraints = false
        
        let top = imageViewThree.topAnchor.constraint(equalTo: imageViewTwo.bottomAnchor)
        let leading = imageViewThree.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
        let trailing = imageViewThree.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        let height = imageViewThree.heightAnchor.constraint(equalToConstant: heightImage)
        
        NSLayoutConstraint.activate([top, leading, trailing, height])
    }
    
    func setupImageViewFourConstraints() {
        imageViewFour.translatesAutoresizingMaskIntoConstraints = false
        
        let top = imageViewFour.topAnchor.constraint(equalTo: imageViewThree.bottomAnchor)
        let leading = imageViewFour.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
        let trailing = imageViewFour.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        let height = imageViewFour.heightAnchor.constraint(equalToConstant: heightImage)
        
        NSLayoutConstraint.activate([top, leading, trailing, height])
    }
    
    
    func asyncLoadImage(imageURL: URL,
                        runQueue: DispatchQueue,
                        complitionQueue: DispatchQueue,
                        complition: @escaping (UIImage?, Error?) -> ()) {
        
        runQueue.async {
            
            do {
                let data = try Data(contentsOf: imageURL)
                complitionQueue.async { complition(UIImage(data: data), nil) }
            } catch let error {
                complitionQueue.async { complition(nil, error) }
            }
        }
        
    }
    
    
    func asyncGroup() {
        let aGroup = DispatchGroup()
        
        for i in 0..<imageURLs.count {
            aGroup.enter() // сообщаем группе о том, что в цикле будет выполнена новая задача aGroup +1
            asyncLoadImage(imageURL: URL(string: imageURLs[i])!, runQueue: .global(), complitionQueue: .main) { result, error in
                            guard let image1 = result else { return }
                            self.images.append(image1)
                            aGroup.leave() // уменьшаем счетчик внутренней группы aGroup -1
            }
        }
        // Когда счетчик достигает нуля, это означает, что все добавленные задачи в группу завершились, и группа запускает зарегистрированный обработчик notify(queue:)
        aGroup.notify(queue: .main) {
            for i in 0..<self.imageURLs.count { self.arrayImage[i].image = self.images[i] }
        }
        
    }
    
    
    func asyncURLSession() {
        
        for i in 0..<imageURLs.count {
            let url = URL(string: imageURLs[i])
            let request = URLRequest(url: url!)
            let task = URLSession.shared.dataTask(with: request) { data, reponse, error in
                DispatchQueue.main.async {
                    self.arrayImage[i].image = UIImage(data: data!)
                }
            }
            task.resume()
        }
        
    }
    

}
