import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// класс будет представлять потокобезопасную обертку над массивом
class SafeArray<Element> {
    private var array = [Element]()
    private let quene = DispatchQueue(label: "DispatchBarrier", attributes: .concurrent) // очередь для добавления элементов в массив с использованием барьерных операций. Атрибут concurrent указывает, что очередь параллельная.
    
    func append(_ element: Element) {
        quene.async(flags: .barrier) { // асинхронная операция (.sync) использует барьерную операцию, гарантирующую добавление элемента последовательно и безопасно в контексте многопоточности.
            self.array.append(element)
        }
    }
    
    // определение вычисляемого свойства elements, возвращающего текущее состояние массива элементов
    var elements: [Element] {
        var result = [Element]()
        quene.sync { // следующий блок кода выполняется синхронно на параллельной очереди, что блокирует текущий поток выполнения, пока блок кода не завершится.
            result = self.array
        }
        return result
    }
    
}


var safeArray = SafeArray<Int>()
DispatchQueue.concurrentPerform(iterations: 10) { index in
    safeArray.append(index)
}
print("safeArray: \(safeArray.elements)")


var array = [Int]()
// concurrentPerform запускает указанное замыкание параллельно в нескольких потоках. Количество потоков, в которых выполняется замыкание, определяется системой автоматически не зависимо от пользователя, основываясь на доступных ядрах процессора и текущей загрузке системы.
DispatchQueue.concurrentPerform(iterations: 10) { index in
    array.append(index)
}
print("array: \(array)")
