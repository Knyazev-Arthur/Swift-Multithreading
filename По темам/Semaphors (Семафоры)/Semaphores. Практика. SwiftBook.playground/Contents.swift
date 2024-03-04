
import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let queue = DispatchQueue(label: "ru.swiftbook.semaphores", attributes: .concurrent)
let semaphore = DispatchSemaphore(value: 2) // до 2 потоков одновременно могут получить доступ к критической секции кода, защищенной семафором. Остальные потоки будут ожидать освобождения семафора.

queue.async {
    semaphore.wait(timeout: .distantFuture) // .distantFuture в качестве аргумента для timeout означает, что поток будет заблокирован до тех пор, пока счетчик семафора не станет > 0, независимо от времени.
    sleep(4) // ожидание 4 секунды
    print("Block 1")
    semaphore.signal() // освобождаем семафор, увеличивая счетчик семафора на 1
}

queue.async {
    semaphore.wait(timeout: .distantFuture)
    sleep(2)
    print("Block 2")
    semaphore.signal()
}

queue.async {
    semaphore.wait(timeout: .distantFuture)
    print("Block 3")
    semaphore.signal()
}

queue.async {
    semaphore.wait(timeout: .distantFuture)
    print("Block 4")
    semaphore.signal()
}
