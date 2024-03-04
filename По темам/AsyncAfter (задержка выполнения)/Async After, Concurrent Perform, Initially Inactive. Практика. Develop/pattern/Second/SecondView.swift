import UIKit

// MARK: - UserProfileViewProtocol
protocol SecondViewProtocol: UIView {
    var secondViewController: SecondViewController? { get set }
}

class SecondView: UIView, SecondViewProtocol {
    
    weak var secondViewController: SecondViewController?
    private let label = UILabel()

    init() {
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
        label.text = "Hello"
        addSubview(label)
        setupLabelConstraints()
        myInactiveQueue()
    }
    
    func forI() {
//        for i in 0...200_000 { print(i) }
        
//        DispatchQueue.concurrentPerform(iterations: 200_000) { i in
//            print(i)
//            print(Thread.current) // iOS автоматически паралелить эту задачу между потоками (главным и нашим)
//        }
        
//        let queue = DispatchQueue.global(qos: .utility)
//        queue.async {
//            DispatchQueue.concurrentPerform(iterations: 200_000) { i in
//                print(i)
//                print(Thread.current)
//            }
//        }
            
    }
    
    func myInactiveQueue() {
        let inactiveQueue = DispatchQueue(label: "The Swift Dev", attributes: [.concurrent, .initiallyInactive])
        
        inactiveQueue.async {
            print("Done !")
        }
        
        print("not yet startet...")
        inactiveQueue.activate()
        print("I am activate!")
        inactiveQueue.suspend()
        print("Pause (sleep) !")
        inactiveQueue.resume()
    }
    
    func setupLabelConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let centerX = label.centerXAnchor.constraint(equalTo: centerXAnchor)
        let centerY = label.centerYAnchor.constraint(equalTo: centerYAnchor)
        
        NSLayoutConstraint.activate([centerX, centerY])
    }
    
}
