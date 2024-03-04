import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// метод DispatchQueue(label:) создает очередь GCD с заданной меткой с дефолтной (стандартной) приоритетностью. Метка используется для идентификации очереди в отладочных сообщениях.
class QueueTest1 {
    private let serialQueue = DispatchQueue(label: "serialTest") // серийная (по умолчанию)
    private let concurrentlQueue = DispatchQueue(label: "concurrentTest", attributes: .concurrent) // паралельная (concurrent)
}

class QueueTest2 {
    private let globalQueue = DispatchQueue.global()
    private let mainQueue = DispatchQueue.main
}
