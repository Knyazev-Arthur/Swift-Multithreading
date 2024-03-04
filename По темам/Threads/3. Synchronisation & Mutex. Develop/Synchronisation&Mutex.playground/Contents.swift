import UIKit

// класс для якобы безопасного потока
//class SaveThread {
//
//    private var mutex = pthread_mutex_t()
//
//    init() {
//        pthread_mutex_init(&mutex, nil) // инициализация mutex
//    }
//
//    // метод, в котором будет производиться защита и разблокировка объекта
//    func someMethod(completion: () -> ()) {
//        pthread_mutex_lock(&mutex) // блокировка данных
//        completion() // задачи, связанные с объектом
//        defer { // defer гарантирует разблокировку объекта, даже в случае, если с объектом произойдет ошибка
//           pthread_mutex_unlock(&mutex) // разблокировка доступа к объекту. Ровно в этом моменте, потоки, запршиваемые доступ к объекту ранее, произведут свои манипуляции с объектом.
//        }
//    }

//}

// реализация метода на Objective-C
class SaveThread {
    
    private var lockMutex = NSLock()
    
    func someMethod(completion: () -> ()) {
        lockMutex.lock()
        completion()
        defer {
            lockMutex.unlock()
        }
    }
    
}

var array = [String]()
let saveThread = SaveThread()

saveThread.someMethod {
    print("Tecт")
    array.append("1 thread")
}

array.append("2 thread")
