import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let mySerialQueue = DispatchQueue(label: "DispatchQueueValue")
var value = "😎"

func changeValue(variant: Int) {
    sleep(1)
    value = value + "🐓"
    print("\(value) - \(variant)")
}

//
/*
 Когда вы вызываете mySerialQueue.async, задача помещается в очередь на выполнение в фоновом потоке, но основной поток продолжает выполнение далее без ожидания завершения задачи. Поэтому вызов print(value) выполняется сразу после добавления задачи в очередь, не дожидаясь ее выполнения. Это означает, что основной поток продолжает выполнение и выводит текущее значение переменной value, которое еще не было изменено задачей в фоновом потоке.
 */
//mySerialQueue.async {
//    changeValue(variant: 1)
//}
//print(value)
//это пример гонки данных (race condition). Гонка данных возникает, когда несколько потоков или процессов пытаются одновременно получить доступ к общим данным и изменить их, при этом порядок выполнения операций не определен заранее. В вашем случае, основной поток и асинхронная задача выполняются параллельно, и изменение значения переменной value может произойти после того, как основной поток уже вывел ее значение.

mySerialQueue.sync {
    changeValue(variant: 1)
}
print(value)

value = "🦉"
mySerialQueue.sync {
    changeValue(variant: 1)
}
print(value)
