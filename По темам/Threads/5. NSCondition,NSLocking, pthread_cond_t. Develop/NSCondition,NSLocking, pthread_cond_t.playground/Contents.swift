import UIKit

// пример многопоточного программирования с использованием мьютексов (mutex) и условных переменных (condition variables) для синхронизации доступа к общему ресурсу (переменной avialable)

// создание предиката
//var avialable = false
//var condition = pthread_cond_t()
//var mutex = pthread_mutex_t()
//
//// поток для работы с общим ресурсом
//class ContinionMutexPriter: Thread {
//
//    override init() {
//        pthread_cond_init(&condition, nil)
//        pthread_mutex_init(&mutex, nil)
//    }
//    // переопределяется метод main() для выполнения основной логики потока
//    override func main() {
//        printMethod()
//    }
//
//    private func printMethod() { // Метод printMethod() выполняет операцию печати
//        pthread_mutex_lock(&mutex) // блокировка mutex
//        print("Printer enter") // уведомление о входе в метод
//        while (!avialable) { // если avialable не равен true
//            pthread_cond_wait(&condition, &mutex) // поток ожидает сигнала об изменении condition
//        }
//        avialable = false // после получения сигнала поток продолжает выполнение, устанавливает флаг avialable в false (показывая, что общий ресурс занят)
//        defer {
//            pthread_mutex_unlock(&mutex) // разблокировка mutex
//        }
//        print("Printer exit") // уведомление о выходе в метод
//    }
//
//}
//
//class ContinionMutexWriter: Thread {
//
//    override init() {
//        pthread_cond_init(&condition, nil)
//        pthread_mutex_init(&mutex, nil)
//    }
//
//    override func main() {
//        writeMethod()
//    }
//
//    private func writeMethod() { // Метод writeMethod() выполняет операцию записи
//        pthread_mutex_lock(&mutex)
//        print("writer enter")
//        avialable = true // устанавливает флаг avialable в true (показывая, что общий ресурс доступен для записи),
//        pthread_cond_signal(&condition) // отправляет сигнал о изменении условной переменной
//        defer {
//            pthread_mutex_unlock(&mutex)
//        }
//        print("writer exit")
//    }
//
//}
//
//let continionMutexWriter = ContinionMutexWriter()
//let continionMutexPriter = ContinionMutexPriter()
//continionMutexPriter.start()
//continionMutexWriter.start()

// реализация на Objective-C
let conditions = NSCondition() // объект NSCondition представляет собой комбинацию мьютекса и условной переменной, используемых для синхронизации потоков.
var availables = false // availables представляет собой общий ресурс, к которому имеют доступ потоки

class WriterThread: Thread {
    
    override func main() {
        conditions.lock()
        print("WriterThread enter")
        availables = true
        conditions.signal() // signal() используется для уведомления одного или нескольких потоков о том, что определенное условие теперь выполнилось и они могут продолжить выполнение.
        conditions.unlock()
        print("WriterThread exit")
    }
    
}

class Printer: Thread {
    
    override func main() {
        conditions.lock()
        print("Printer enter")
        while (!availables) {
            conditions.wait()
        }
        availables = false
        conditions.unlock()
        print("Printer exit")
    }
    
}

let writer = WriterThread()
let printer = Printer()
printer.start()
writer.start()
