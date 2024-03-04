import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true


DispatchQueue.main
DispatchQueue.global(qos: .userInteractive) // приоритет userInteractive необходим при операциях, выполнение которых пользователь ждет прямо сейчас (запрос в интернет при авторизации в приложении)
DispatchQueue.global(qos: .userInitiated) // пользователь готов немного подождать (загрузка изображений)
DispatchQueue.global(qos: .utility) // пользователю не важно, чтобы работа выполнилась прямо сейчас
DispatchQueue.global(qos: .background) // выполнение операций в фоне. Пользователю не важно
DispatchQueue.global(qos: .default) // в зависимости от автоматической оценки важности операции выбирает приоритет userInteractive / userInitiated


let mainQueue = DispatchQueue.main // используем при необходимости выполнения задачи на главном потоке. Не рекомендуется, т.к. главнй поток априори занят важными вещами
let userInteractive = DispatchQueue.global(qos: .userInteractive)
let justGlobal = DispatchQueue.global() // используем при выполнении малозатратных операций. Приоритет установиться автоматически. Способ выполения автоматически станет синхронным.
let userUtility = DispatchQueue.global(qos: .utility)


//justGlobal.sync {
//    for i in 0...10 { print("just sync", i) }
//}
//
//justGlobal.async {
//    for i in 0...10 { print("just async", i) }
//}
//
//justGlobal.asyncAfter(deadline: .now() + 5) { // выполнение операции асинхронно с задержкой
//    print("after")
//}
//
//for i in 0...10 { print("just", i) }


//userInteractive.async {
//    for i in 0...1000 { print("userInteractive", i) } // все ресурсы процессора отдаются этой операции, т.к. ее приоритет выше
//}
//
//userUtility.async {
//    for i in 0...1000 { print("userUtility", i) }
//}
//
//
//print("World!")


//let ownQueue2 = DispatchQueue(label: "ownQueue2", qos: .userInteractive, attributes: .initiallyInactive, autoreleaseFrequency: .workItem, target: userInteractive) // код, запланированный для выполнения в ownQueue2, будет фактически выполняться на очереди userInteractive, указанной в target

//let ownQueue = DispatchQueue(label: "ownQueue", qos: .utility, attributes: .initiallyInactive, autoreleaseFrequency: .workItem, target: userInteractive) // флаг initiallyInactive делает очередь неактивной по умолчанию. autoreleaseFrequency отвечаетза способ управления памятью
//// workItem очищает пул памяти, которая выделялась для операции, при каждой итерации. Тем самым после выполнения операции память не будет занята 10 000 строк.
//// never - означает, что автомтическая отчистка пула памяти не произойдет никогда
//
//ownQueue.async {
//    for i in 0...10 {
//        let newString = String(i)
//        print("ownQueue", newString)
//        sleep(1)
//    }
//}
//
//sleep(2)
//ownQueue.activate()
//sleep(3)
//ownQueue.suspend() // деактивация (suspend) очереди, возможна только активированную очереди. Также suspend приостанавливает очередь, но не выполняющееся в ней задание.
//sleep(5)
//ownQueue.resume() // resume возобнавляет только приостанавливленную очередь

//DispatchWorkItemFlags.barrier - задача подождет выполнения всех уже добавленных заданий и остановит все остальные задания на время выполнения
//DispatchWorkItemFlags.detached - создаст новый поток для выполения
//DispatchWorkItemFlags.assignCurrentContext - берет QoS во время выполнения
//DispatchWorkItemFlags.enforceQoS - увеличивает приоритет задачи по отношению к остальным
//DispatchWorkItemFlags.noQoS —
//ODispatchWorkItemFlags.inheritQoS - наследует QoS во время добавления

//userUtility.async {
//    for i in 0...100 {
//        let newString = String(i)
//        print("just", newString)
//    }
//}
//
//userUtility.async {
//    for i in 0...100 {
//        let newString = String(i)
//        print("just2", newString)
//    }
//}
// блок кода будет иметь более высокий приоритет выполнения по сравнению с первыми двумя блоками кода
//userUtility.async(qos: .userInteractive, flags: .enforceQoS) {
//    for i in 0...100 {
//        let newString = String(i)
//        print("just3", newString)
//    }
//}
