import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true



// MARK: Experience 1. Задачи в глобальных очередях
let mainQueue = DispatchQueue.main // главная очередь, последовательная по умолчанию

// Глобальные очереди с указанием класса качества обслуживания (QoS), гарантирующего операции соответствующюю приоритетность
let userInteractiveQueue = DispatchQueue.global(qos: .userInteractive)
let userQueue = DispatchQueue.global(qos: .userInitiated)
let utilityQueue = DispatchQueue.global(qos:  .utility)
let backgroundQueue = DispatchQueue.global(qos:  .background)
let defaultQueue = DispatchQueue.global() // qos: .default по умолчанию

// Функция qos_class_self() определяет класс QoS, ассоциированое с текущим потоком.
// Без указания очереди все функции апрори вызываются в главной очереди, использующей главный поток.
func task(_ symbol: String) { for i in 1...6 {
    print("\(symbol) \(i) приоритет = \(qos_class_self().rawValue)")
    }
}

func taskHIGH(_ symbol: String) {
    print("\(symbol) HIGH приоритет = \(qos_class_self().rawValue)")
}

//task("Hello")
//taskHIGH("A")



// MARK: Experience 2. Sync Async
/*
print("---------------------------------------------------")
print("   СИНХРОННОСТЬ sync ")
print("   Global .concurrent Q1 - .userInitiated ")
print("---------------------------------------------------")
userQueue.sync { task("😀") }
task("👿")
sleep (2)

print("---------------------------------------------------")
print("   АСИНХРОННОСТЬ async ")
print("   Global .concurrent Q1 - .userInitiated ")
print("---------------------------------------------------")
userQueue.async {task("😀")}
task("👿")
*/


// MARK: Experience 3. Последовательная очередь
// при самостоятельном вызове очереди через инициализатор mySerialQueue необходимо указать уникальный label, который будет отображен в панели отладки
let mySerialQueue = DispatchQueue(label: "com.bestkora.mySerial") // по умолчанию очередь является последовательной
/*
print("---------------------------------------------------")
print("   СИНХРОННОСТЬ sync ")
print("   Private .serial Q1 - no ")
print("---------------------------------------------------")

mySerialQueue.sync { task("😀")}
task("👿")

print("---------------------------------------------------")
print("   АСИНХРОННОСТЬ async ")
print("   Private .serial Q1 - no ")
print("---------------------------------------------------")
 
// Метод async используется для добавления задачи в очередь и продолжения выполнения кода без ожидания завершения добавленной задачи. Однако, задачи все равно будут выполняться последовательно, одна за другой, как только для них освободится поток выполнения.
mySerialQueue.async { task("😀")}
task("👿")
*/

 

// MARK: Experience 4. Последовательная очередь с одинаковым QoS
/*
print("---------------------------------------------------")
print("   Private .serial Q1 - .userInitiated ")
print("---------------------------------------------------")

let serialPriorityQueue = DispatchQueue(label: "com.bestkora.serialPriority", qos : .userInitiated)

// serialPriorityQueue является последовательной, и несмотря на использование async метода, задания выполняются последовательно
serialPriorityQueue.async { task("😀") }
serialPriorityQueue.async { task("👿") }
sleep(1)
 */



// MARK: Последовательная очередь с разными QoS
/*
print("---------------------------------------------------")
print("   Private .serial Q1 - .userInitiated")
print("                   Q2 - .background ")
print("---------------------------------------------------")

// многопоточное выполнение задач на очереди с более высоким QoS происходит чаще
let serialPriorityQueue1 = DispatchQueue(label: "com.bestkora.serialPriority", qos : .userInitiated)
let serialPriorityQueue2 = DispatchQueue(label: "com.bestkora.serialPriority", qos : .background)
serialPriorityQueue2.async { task("😀") }
serialPriorityQueue1.async { task("👿") }
sleep(1)
*/



// MARK: asyncAfter c изменением приоритета
/*
print("---------------------------------------------------")
print("   asynAfter (.userInteractiv) на Q2")
print("   Private .serial Q1 - .utility")
print("                   Q2 - .background")
print("---------------------------------------------------")

let serialUtilityQueue = DispatchQueue(label: "com.bestkora.serialUtilityriority", qos : .utility)
let serialBackgroundQueue = DispatchQueue(label: "com.bestkora.serialBackgroundPriority", qos : .background)

// asyncAfter позволяет переизменить QoS и задержать выполнение заданий на любой очереди DispatchQueue на заданное время
serialBackgroundQueue.asyncAfter (deadline: .now() + 0.1, qos: .userInteractive) { task("👿") }
serialUtilityQueue.async { task("😀") }
sleep (1)
 */




// MARK: Experience 5. Параллельная очередь

// MARK: highPriorityItem = DispatchWorkItem
/*
//let highPriorityItem = DispatchWorkItem(qos: .userInteractive, flags:[.enforceQoS, .assignCurrentContext]) {
let highPriorityItem = DispatchWorkItem (qos: .userInteractive, flags:[.enforceQoS]){
    taskHIGH("🌺")
}

print("---------------------------------------------------")
print(" Private  .concurrent Q - .userInitiated ")
print("---------------------------------------------------")

let workerQueue = DispatchQueue(label: "com.bestkora.worker_concurrent", qos: .userInitiated, attributes: .concurrent)
workerQueue.async  { task("😀") }
workerQueue.async {task("👿") } // указанная задача, будучи поставленной 2-ой, иногда выполняется раньше 1-ой, поскольку задачи выполняются в парал-ом потоке
sleep (2)
 */



// MARK: Параллельные очереди c разными приоритетами
/*
print("---------------------------------------------------")
print("    .concurrent Q1 - .userInitiated ")
print("                Q2 - .background ")
print("---------------------------------------------------")

// из 2-ух парал-ых очередей выполняться операций быстрее будут в той, чей приоритет выше
let workerQueue1 = DispatchQueue(label: "com.bestkora.worker_concurrent1",  qos: .userInitiated, attributes: .concurrent)
let workerQueue2 = DispatchQueue(label: "com.bestkora.worker_concurrent1",  qos: .background, attributes: .concurrent)

workerQueue2.async  {task("😀")}
workerQueue1.async {task("👿")}
//workerQueue1.async(execute: highPriorityItem)
//workerQueue2.async(execute: highPriorityItem)
sleep (1)
 */



// MARK: Параллельные очереди c отложенным выполнением
/*
print("---------------------------------------------------")
print(" Параллельная очередь c отложенным выполнением")
print(" Private  .concurrent Q - .userInitiated, .initiallyInactive")
print("---------------------------------------------------")

// Флаг initiallyInactive применяется для указания того, что операция не должна начинать выполнение сразу после добавления в очередь, а только при активации
let workerDelayQueue = DispatchQueue(label: "com.bestkora.worker_concurrent", qos: .userInitiated, attributes: [.concurrent, .initiallyInactive])
workerDelayQueue.async  {task("😀")}
workerDelayQueue.async {task("👿")}
sleep (3)
print("---------------------------------------------------")
print(" Выполнение заданий на параллельной очереди")
print(" с отложенным выполнением")
print("---------------------------------------------------")
workerDelayQueue.activate()
sleep (1)
 */


// MARK: Experience 6. DispatchWorkItem
let highPriorityItem = DispatchWorkItem (qos: .userInteractive, flags:[.enforceQoS]) {
    taskHIGH("🌺")
}
