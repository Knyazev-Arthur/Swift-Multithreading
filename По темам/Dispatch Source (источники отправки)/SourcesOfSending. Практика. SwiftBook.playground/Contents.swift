import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let queue = DispatchQueue(label: "ru.swiftbook.sources", attributes: .concurrent)
let timer = DispatchSource.makeTimerSource(queue: queue) // инициализация источника таймера с помощью статического метода makeTimerSource

timer.schedule(deadline: .now(), repeating: .seconds(2), leeway: .milliseconds(300)) // расписание для источника таймера. Он будет срабатывать каждые 2 секунды с учетом погрешности в 300 миллисекунд.
timer.setEventHandler { // обработчик событий для таймера. При срабатывании (каждые 2 сек) выполняется код.
    print("Hello world")
}

timer.setCancelHandler { // обработчик событий для таймера. При остановке выполняется код.
    print("Timer is cancelled")
}

timer.resume() // запуск источника таймера
sleep(5)
timer.cancel() // остановка таймера
