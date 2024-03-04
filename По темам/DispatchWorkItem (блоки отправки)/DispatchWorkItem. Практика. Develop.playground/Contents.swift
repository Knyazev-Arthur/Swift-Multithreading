import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

class DispatchWorkItemOne {
    
    private let queue = DispatchQueue(label: "DispatchWorkItemOne", attributes: .concurrent) // паралелльная очередь
    
    func create() {
        let workItem = DispatchWorkItem { // DispatchWorkItem - объект, представляющий собой блок кода, который может быть выполнен в очереди диспетчера (DispatchQueue).
            print(Thread.current)
            print("Start task")
        }
        
        // метод указывает, что после завершения выполнения блока кода workItem, должен быть выполнен указанный блок кода на главной (main) очереди.
        workItem.notify(queue: .main) {
            print(Thread.current)
            print("Task finish")
        }
        
        queue.async(execute: workItem)
    }
    
}

//let dispatchWorkItemOne = DispatchWorkItemOne()
//dispatchWorkItemOne.create()

class DispatchWorkItemTwo {
    
    private let queue = DispatchQueue(label: "DispatchWorkItemTwo") // последовательная (по умолчанию) очередь
    
    func create() {
        queue.async {
            sleep(1)
            print(Thread.current)
            print("Task 1")
        }
        
        queue.async {
            sleep(1)
            print(Thread.current)
            print("Task 2")
        }
        
        let workItem = DispatchWorkItem {
            print(Thread.current)
            print("Start workItem task 3")
        }
        
        queue.async(execute: workItem)
        
        workItem.cancel() // отменять задачи в workItem можно до начала его выполнения. После начала
    }
    
}

//let dispatchWorkItemTwo = DispatchWorkItemTwo()
//dispatchWorkItemTwo.create()



var view = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
var image = UIImageView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))

image.backgroundColor = .yellow
image.contentMode = .scaleAspectFit
view.addSubview(image)

PlaygroundPage.current.liveView = view
let imageURL = URL(string: "https://images.wallpaperscraft.ru/image/single/volkswagen_avtomobil_furgon_1170875_3840x2160.jpg")!

// classic
func fetchImage() {
    let queue = DispatchQueue(label: "DispatchQueueImageLoad", qos: .utility)
    
    queue.async {
        guard let data = try? Data(contentsOf: imageURL) else { return }
        DispatchQueue.main.async {
            image.image = UIImage(data: data)
        }
    }
}

// fetchImage()

// DispatchWorkItem
func fetchImage2() {
    var data: Data?
    
    let queue = DispatchQueue(label: "DispatchQueueImageLoad", qos: .utility)
    let workItem = DispatchWorkItem(qos: .userInteractive) {
        data = try? Data(contentsOf: imageURL)
        print(Thread.current)
    }
    
    queue.async(execute: workItem)
    
    workItem.notify(queue: .main) {
        guard let imageData = data else { return }
        image.image = UIImage(data: imageData)
    }
}

//fetchImage2()

// URLSession
func fetchImage3() {
    var task = URLSession.shared.dataTask(with: imageURL) { data, response, error in
        print(Thread.current)
        
        guard let imageData = data else { return }
        DispatchQueue.main.async {
            print(Thread.current)
            image.image = UIImage(data: imageData)
        }
    }
    task.resume()
}

fetchImage3()
