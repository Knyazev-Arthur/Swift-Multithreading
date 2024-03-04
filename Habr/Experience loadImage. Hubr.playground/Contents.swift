import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

var view = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
var eiffelImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
eiffelImage.backgroundColor = UIColor.yellow
eiffelImage.contentMode = .scaleAspectFit
view.addSubview(eiffelImage)
let imageURL = URL(string: "https://histrf.ru/images/common/28/RW12Zxfvv6avnJquv2PUMiYyaYu0aDa6vcOuOQ2N.jpg")!
PlaygroundPage.current.liveView = view



// MARK: Загрузка изображения классическим способом
func fetchImage0() {
    let queue = DispatchQueue.global(qos: .utility)
    queue.async{
        if let data = try? Data(contentsOf: imageURL){
            DispatchQueue.main.async {
                eiffelImage.image = UIImage(data: data)
            }
        }
    }
}

//fetchImage0()



// MARK: Загрузка с помощью URLSession
func fetchImage1() {
    let task = URLSession.shared.dataTask(with: imageURL){ (data, _, _) in
        if let imageData = data {
            DispatchQueue.main.async {
                print("Show image data")
                eiffelImage.image = UIImage(data: imageData)
            }
            print("Did download  image data")
        }
    }
    task.resume()
}
//fetchImage1()



// MARK: Загрузка с помощью DispatchWorlItem
func fetchImage2() {
    var data: Data?
    let queue = DispatchQueue.global(qos: .utility)
    let workItem = DispatchWorkItem (qos:.userInteractive ) {data = try? Data(contentsOf: imageURL)}
//:  Если cancel используется перед async, то workItem не размещается в очереди.
    queue.async(execute: workItem)
    workItem.cancel() //: cancel() используется для отмены выполнения операции или работы, которая была добавлена в очередь GCD (Grand Central Dispatch), но еще не начала выполнение
    workItem.notify(queue: DispatchQueue.main) {
        if data != nil { //: если data не равно nil
            eiffelImage.image = UIImage(data: data!)}
    }
}
//fetchImage2()



// MARK: Асинхронная обертка синхронной операции - загрузки изображение
func asyncLoadImage(imageURL: URL,
                    runQueue: DispatchQueue, // Очередь, на которой будет выполняться операция загрузки данных изображения.
                    completionQueue: DispatchQueue, // Очередь, на которой будет выполнен обработчик завершения
                    completion: @escaping (UIImage?) -> ()) { // Замыкание, которое будет вызвано после завершения операции загрузки.
    runQueue.async {
        do {
            let data = try Data(contentsOf: imageURL)
            completionQueue.async { completion(UIImage(data: data))}
        } catch {
            completionQueue.async { completion(nil)}
        }
    }
}

func fetchImage3() {
    asyncLoadImage(imageURL: imageURL,
                   runQueue: DispatchQueue.global(),
                   completionQueue: DispatchQueue.main)
    { result in
        guard let image = result else {return}
        eiffelImage.image = image
    }
}

fetchImage3()
