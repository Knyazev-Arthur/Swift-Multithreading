import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let queue = DispatchQueue.init(label: "ru.swiftbook", attributes: .concurrent)
let group = DispatchGroup() // объект группы отправки group, который будет отслеживать выполнение задач, добавленных в него.

// Метод async добавляет задачу в очередь queue. Задача автоматически входит в группу отправки group.
queue.async(group: group) { // группа будет использоваться для организации задач в рамках параллельного выполнения
    for i in 1...10 {
        if i == 10 {
            print(i)
        }
    }
}

queue.async(group: group) {
    for i in 1...20 {
        if i == 20 {
            print(i)
        }
    }
}

// метод notify(queue:execute:) объекта группы отправки (DispatchGroup) для выполнения заданного замыкания после завершения всех задач, добавленных в группу
group.notify(queue: .main) { // .main указывает, что замыкание будет выполнено на главной очереди (main queue)
    print("Все закончено в группе - group")
}



let secondGroup = DispatchGroup()

secondGroup.enter()

queue.async(group: secondGroup) {
    for i in 1...30 {
        if i == 30 {
            print(i)
            sleep(2)
            secondGroup.leave()
        }
    }
}

// .wait: Этот метод блокирует текущий поток выполнения до тех пор, пока все задачи в группе отправки secondGroup
let result = secondGroup.wait(timeout: .now() + 1) // + 1 добавляет 1 секунду к текущему времени, задавая временную точку, до которой нужно ожидать завершение задач
// Если все задачи в группе secondGroup завершились в течение указанного времени ожидания, то result будет равен .success.
// Если время ожидания истекло до завершения всех задач, то result будет равен .timedOut.
print(result)

secondGroup.notify(queue: .main) {
    print("Все закончено в группе - secondGroup")
}

print("Этот принт должен быть выполнен выше, чем последний")

secondGroup.wait()
