import UIKit

let recursiveLoack = NSRecursiveLock()

class RecursiveMutexTest {
    private var mutex = pthread_mutex_t()
    private var attribut = pthread_mutexattr_t()
    
    init() {
        pthread_mutexattr_init(&attribut)
        pthread_mutexattr_settype(&attribut, PTHREAD_MUTEX_RECURSIVE)
        pthread_mutex_init(&mutex, &attribut)
    }
    
    func firstTask() {
        pthread_mutex_lock(&mutex)
        twoTask()
        defer {
            pthread_mutex_unlock(&mutex)
        }
    }
    
    private func twoTask() {
        pthread_mutex_lock(&mutex)
        print("Finish")
        defer {
            pthread_mutex_unlock(&mutex)
        }
    }
    
}

let recursive = RecursiveMutexTest()
recursive.firstTask()


// Реализация на Objective-C
class RecursiveThread: Thread {
        
    override func main() {
        recursiveLoack.lock()
        print("Thread lock")
        callMe()
        defer {
            recursiveLoack.unlock()
        }
        print("Exit main")
    }
    
    func callMe() {
        recursiveLoack.lock()
        print("Thread lock")
        defer {
            recursiveLoack.unlock()
        }
        print("Exit callMe")
    }
}

let thread = RecursiveThread()
thread.start()
