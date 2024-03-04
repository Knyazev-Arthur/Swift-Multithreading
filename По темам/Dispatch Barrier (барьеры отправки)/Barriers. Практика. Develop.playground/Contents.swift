import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

//var arrayInt = [Int]()
////for i in 0...9 { // последовательное добавление данных в массив
//DispatchQueue.concurrentPerform(iterations: 10) { i in // параллельное добавление данных в массив (гонка данных)
//    arrayInt.append(i)
//}
//
//print("\(arrayInt)\n\(arrayInt.count)")


class SafeArray<T> { // T обобщенный (дженерик) тип данных
    private var array = [T]()
    private let queue = DispatchQueue(label: "The Swift Developers", attributes: .concurrent) // параллельная очередь
    
    func app(_ value: T) {
        queue.async(flags: .barrier) { // Барьерная операция гарантирует, что все операции в очереди будут выполнены в порядке, в котором они добавлены, и что ни одна другая операция не выполнится параллельно с ней. Это позволяет избежать гонки данных.
            self.array.append(value)
        }
    }
    
    var valueArray: [T] {
        var result = [T]()
        queue.sync {
            result = self.array
        }
        return result
    }
    
}

var arraySafe = SafeArray<Int>()
DispatchQueue.concurrentPerform(iterations: 10) { i in
    arraySafe.app(i)
}
print("\(arraySafe.valueArray)\n\(arraySafe.valueArray.count)")


