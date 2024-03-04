import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let queueTimer = DispatchQueue(label: "Timer")

let timer = DispatchSource.makeTimerSource(queue: queueTimer)
timer.setEventHandler { // обработчик событий таймера
    print("!") // при каждом србатывании таймера будет выполняться код
}

timer.schedule(deadline: .now(), repeating: 5)
timer.activate()
