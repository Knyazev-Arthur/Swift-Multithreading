import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true
//
//let queue = DispatchQueue(label: "The Swift Developer", attributes: .concurrent)
//
//// семафор DispatchSemaphore используется для ограничения количества одновременно выполняющихся задач
//let semaphore = DispatchSemaphore(value: 0) // до N (value) потоков могут получить доступ к критическому участку кода одновременно благодаря семафору
//
//queue.async {
//    semaphore.wait() // - 1
//    sleep(3)
//    print("Method 1")
//    semaphore.signal() // + 1
//}
//
//queue.async {
//    semaphore.wait() // - 1
//    sleep(3)
//    print("Method 2")
//    semaphore.signal() // + 1
//}
//
//queue.async {
//    semaphore.wait() // - 1
//    sleep(3)
//    print("Method 3")
//    semaphore.signal() // + 1
//}
//
//
//let sem = DispatchSemaphore(value: 0)
////sem.signal()
//
//DispatchQueue.concurrentPerform(iterations: 10) { id in
//    sem.wait(timeout: .distantFuture)
//    sleep(1)
//    print("Block", id, Thread.current)
//    sem.signal()
//}


class SemaphoreTest {
    
    private let semap = DispatchSemaphore(value: 2)
    var array = [Int]()
    
    func work(id: Int) {
        semap.wait()
        
        array.append(id)
        print("test array")
        
        Thread.sleep(forTimeInterval: 2)
        semap.signal()
    }
    
    func startAllThread() {
        let queue = DispatchQueue(label: "The Swift Developer")
        
        queue.async {
            self.work(id: 111)
            print(Thread.current)
        }
        
        queue.async {
            self.work(id: 234)
            print(Thread.current)
        }
        
        queue.async {
            self.work(id: 23423)
            print(Thread.current)
        }
        
        queue.async {
            self.work(id: 12312)
            print(Thread.current)
        }
    }
    
}
// очередь с четырьмя задачами, каждая из которых вызывает метод work. Все эти задачи будут выполнены асинхронно, но из-за использования семафора semap только две задачи будут выполняться одновременно, что обеспечит ограничение доступа к критической секции.
let semapTest = SemaphoreTest()
semapTest.startAllThread()
