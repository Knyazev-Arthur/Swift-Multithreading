import UIKit

class UserProfileView: UIView {

    init() {
        super.init(frame: .zero)
        // опыт запуска задач в тругих (не в главном) потоках
//        experienceOne()
//        experienceTwo()
//        experienceThree()
//        experienceFour()
//        experienceFive()
//        experienceSix()
//        experienceSeven()
//        experienceEight()
        experienceNine()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension UserProfileView {
    
    func experienceOne() {
        
        print("start")
        print("1")
        print("2")
        
        // пример асинхронного кода, который выполняется потом по запланированному событию
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
            print("is a timer")
            print("3")
            print("4")
        }
        
        print("5")
        print("6")
        print("end")
        
        let i = 0
        while i < 1 { }
        print("7")
    }

    func experienceTwo() {
        print("start")
        print("1")
        print("2")
        
        DispatchQueue.global().async {
            while true {}
            print("3")
            print("4")
        }
        
        print("5")
        print("6")
        print("end")
        
        let i = 0
        while i < 1 { }
        print("7")
    }
    
// MARK: опыт запуска задач в тругих (не в главном) потоках
    
    // первый способ создания потока
    func experienceThree() {
        
        class Thread1: Thread {
            override func main() {
                while true {
                    print("thread 1")
                    Thread.sleep(forTimeInterval: 1)
                }
            }
        }
        
        class Thread2: Thread {
            override func main() {
                while true {
                    print("thread 2")
                    Thread.sleep(forTimeInterval: 1)
                }
            }
        }
        
        let thread1 = Thread1()
        let thread2 = Thread2()
        thread1.start()
        thread2.start()
    }
    
    // способ создания потока доступный с iOS 10
    func experienceFour() {
        print(Thread.current)

        let thread = Thread() { // здесь замыкание заменяет точку входа main
            while true {
                print(Thread.current)
                Thread.sleep(forTimeInterval: 1)
            }
        }
        thread.start()
    }
    
    // способ создания потока доступный в т.ч. до iOS 10
    func experienceFive() {
        
        class Test {
            
            @objc func buy() {
                while true {
                    print("buy")
                    print(Thread.current)
                    Thread.sleep(forTimeInterval: 1)
                }
            }
            
        }
        
        let test = Test()
//        let thread = Thread(target: test, selector: #selector(test.buy), object: nil)
//        thread.start()
        
        // способ создания потока без контроля над потоком
        Thread.detachNewThreadSelector(#selector(test.buy), toTarget: test, with: nil)
    }
    
    // способ создания потока без контроля над потоком
    func experienceSix() {
        Thread.detachNewThread {
            while true {
                print("new thread")
                print(Thread.current)
                Thread.sleep(forTimeInterval: 1)
            }
        }
    }
    
// MARK: опыт управления потоками
    
    func experienceSeven() {
        
        print("main thread", Thread.current)
        
        class Thread1: Thread {
            override func main() { // main является тчк входа (entry point). Выполняется при запуске и завершении потока.
                name = "thread 1" // имя потока полезно для отладки
                while !isCancelled {
                    print("thread 1", Thread.current)
//                    print("isExecuting", isExecuting) // флаг выполнения
//                    print("isCancelled", isCancelled) // флаг остановки
//                    print("isFinished", isFinished) // флаг необходимости остановки
                    print("-----------------------")
                    Thread.sleep(forTimeInterval: 1)
                }
            }
        }
        
        let thread = Thread1()
        thread.start()
        sleep(3) // задержка здесь дает временной промежуток, в течение которого поток Thread1 имеет возможность выполнить некоторую работу и завершиться до того, как основной поток продолжит свое выполнение.
        thread.cancel() // cancel() устанавливает флаг потока isCancelled в true, но не завершает поток
        print(thread.isExecuting, thread.isCancelled, thread.isFinished)
    }
    
    func experienceEight() {
        
        class Thred: Thread {
            override func main() {
                while true {
                    print(Thread.current)
                }
            }
        }
        
        let thread1 = Thred()
        thread1.name = "thread1"
        thread1.qualityOfService = .userInteractive
        
        let thread2 = Thred()
        thread2.name = "thread2"
        thread2.qualityOfService = .utility
        
        thread1.start()
        thread2.start()
    }
    
    func experienceNine() {
    
        class Thred: Thread {
            override func main() {
                while true {
                    print(Thread.current)
                }
            }
        }
        
        let thread1 = Thred()
        thread1.threadDictionary // место, где мы можем хранить информацию полезную для данного потока (например обратываемые в нем данные)
    }
    
}
