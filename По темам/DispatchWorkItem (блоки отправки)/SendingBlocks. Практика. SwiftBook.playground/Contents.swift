import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// создаем объект DispatchWorkItem, но не запускаем его немедленно
let workItem = DispatchWorkItem(qos: .utility, flags: .detached) {
    print("Performing workItem")
}

// выполняем workItem синхронно с помощью метода perform()
//workItem.perform()

let queue = DispatchQueue(label: "ru.swiftbook")

queue.asyncAfter(deadline: .now() + 1, execute: workItem)

workItem.notify(queue: .main) {
    print("workItem кончился")
}


if !workItem.isCancelled {
    print(workItem.isCancelled)
    workItem.cancel()
    print(workItem.isCancelled)
}

workItem.wait()
