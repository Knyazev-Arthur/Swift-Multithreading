import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

class DispatchGroupTestOne {
    
    private let queueSerial = DispatchQueue(label: "The Swift Developer")
    
    private let groupRed = DispatchGroup() // DispatchGroup позволяет группировать несколько задач
    
    func loadInfo() {
        queueSerial.async(group: groupRed) {
            sleep(2)
            print(1)
        }
        
        queueSerial.async(group: groupRed) {
            sleep(2)
            print(2)
        }
        
        groupRed.notify(queue: .main) {
            sleep(2)
            print("Group finish")
        }
    }
    
}

let dispatchGroupTestOne = DispatchGroupTestOne()
dispatchGroupTestOne.loadInfo()


class DispatchGroupTestTwo {
    
    private let queueConc = DispatchQueue(label: "The Swift Developer", attributes: .concurrent)
    
    private let groupBlack = DispatchGroup() // DispatchGroup позволяет группировать несколько задач
    
    // несмотря на то, что созданная нами очередь является параллельной, операции выполняются последовательно
    func loadInfo() {
        groupBlack.enter()
        queueConc.sync {
            sleep(2)
            print(1)
            groupBlack.leave()
        }
        
        groupBlack.enter()
        queueConc.sync {
            sleep(2)
            print(2)
            groupBlack.leave()
        }
        
        groupBlack.wait()
        sleep(2)
        print("Finish all")
    }
    
}

let dispatchGroupTestTwo = DispatchGroupTestTwo()
//dispatchGroupTestTwo.loadInfo()
