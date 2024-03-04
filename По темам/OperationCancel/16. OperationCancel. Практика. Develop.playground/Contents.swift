import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let operationQueue = OperationQueue()

class OperationCancelTest: Operation {
    
    override func main() {
        if isCancelled {
            print(isCancelled)
            return
        }
        
        print("test 1")
        sleep(1)
        
        if isCancelled {
            print(isCancelled)
            return
        }
        
        print("test 2")
    }
    
}

func cancelOperationMethod() {
    let cancelOperation = OperationCancelTest()
    operationQueue.addOperation(cancelOperation) // операция вызвана и начато ее выполнение, а значит здесь она еще не отменена
    cancelOperation.cancel() // вызов cancel() у операции не останавливает ее мгновенно, а устанавливает флаг isCancelled в true, который операция должна проверить самостоятельно в своем коде для обнаружения запроса на отмену. Т.е. операция продолжит выполнение до ближайшей точки проверки isCancelled.
}
//cancelOperationMethod()

class WaitOperationTest {
    
    private let operation = OperationQueue()
    
    func test() {
        operation.addOperation {
            sleep(1)
            print("Test 1")
        }
        
        operation.addOperation {
            sleep(2)
            print("Test 2")
        }
        
        operation.waitUntilAllOperationsAreFinished() // метод, выполняющий последующие операции по мере выполнения предыдущих
        
        operation.addOperation {
            print("Test 3")
        }
        
        operation.addOperation {
            print("Test 4")
        }
    }
    
}

let waitOperationTest = WaitOperationTest()
//waitOperationTest.test()

class WaitOperationTest2 {
    
    private let operation = OperationQueue()
    
    func test() {
        let operation1 = BlockOperation {
            sleep(1)
            print("Test 1")
        }
        
        let operation2 = BlockOperation {
            sleep(2)
            print("Test 2")
        }
        
        operation.addOperations([operation1, operation2], waitUntilFinished: false) // метод, принимающий массив операций, выполняющий последующие операции по мере выполнения предыдущих
        
        operation.addOperation {
            print("Test 3")
        }
        
        operation.addOperation {
            print("Test 4")
        }
    }
    
}

let waitOperationTest2 = WaitOperationTest2()
//waitOperationTest2.test()

class ComplitionBlockTest {
    
    private let operation = OperationQueue()
    
    func test() {
        let operation1 = BlockOperation { // асинхронный блок кода
            sleep(3)
            print("test ComplitionBlock")
        }
        
        operation1.completionBlock = { // блок завершения для операции operation1
            print("Finish ComplitionBlock")
        }
        
        operation.addOperation(operation1)
    }
    
}

let complitionBlockTest = ComplitionBlockTest()
complitionBlockTest.test()
