import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// MARK: Thread.current
print(Thread.current)

//let operation = {
//    print("start")
//    print(Thread.current)
//    print("finish")
//}

//let queue = OperationQueue()
//queue.addOperation(operation) // OperationQueue выполнит блок кода в фоновом потоке автоматически

//var result: String?
//let concatOperation = BlockOperation {
//    result = "The Swift Developer"
//    print(Thread.current)
//}
//concatOperation.start() // BlockOperation выполняет свои блоки на текущей очереди/потоке, на которой он был добавлен/создан.
//print(result ?? "")

//let queue = OperationQueue()
//queue.addOperation {
//    print("start")
//    print(Thread.current)
//}

//class MyThread: Thread {
//    override func main() {
//        print("Test my Thread")
//    }
//}
//
//let myThread = MyThread()
//myThread.main()

class OperationA: Operation {
    override func main() {
        print("Test my Thread")
        print(Thread.current)
    }
}

let operationA = OperationA()
//operationA.main()

let queue = OperationQueue()
queue.addOperation(operationA) // По умолчанию операции, добавленные в OperationQueue, выполняются в фоновом потоке. Даже при создании операции в основной точке входа (когда операция готова к выполнению, система вызывает этот метод, чтобы запустить ее выполнение), которая наследуется от Operation, она будет выполняться в контексте, управляемом OperationQueue.
