import UIKit
// определяем объект блокировки чтения/записи (read-write lock), который позволяет множеству потоков читать данные одновременно, но блокирует их при записи данных.
class ReadWriteLoack {
    private var lock = pthread_rwlock_t()
    private var attribut = pthread_rwlockattr_t()
    
    private var globalProperty = 0
    
    init() {
        pthread_rwlock_init(&lock, &attribut)
    }
    
    var workProperty: Int {
        get {
            pthread_rwlock_wrlock(&lock)
            let temp = globalProperty
            pthread_rwlock_unlock(&lock)
            return temp
        }
        
        set {
            pthread_rwlock_wrlock(&lock)
            globalProperty = newValue
            pthread_rwlock_unlock(&lock)
        }
    }
    
}

// класс использует механизм вращающейся блокировки (spinlock), который активно проверяет, освободилась ли блокировка, вместо того чтобы переключаться в режим ожидания.
// реализация до iOS 10
class SpinLoack {
    private var lock = OS_SPINLOCK_INIT
    
    func some() {
        OSSpinLockLock(&lock)
        // задача
        OSSpinLockUnlock(&lock)
    }
}

// В этом классе используется "несправедливая" блокировка (unfair lock), введенная в iOS 10, которая обеспечивает более предсказуемое поведение по сравнению с вращающейся блокировкой.
// реализация после iOS 10
class UnfairLoack {
    private var lock = os_unfair_lock_s()
    
    var array = [Int]()
    
    func some() {
        os_unfair_lock_lock(&lock)
        array.append(1)
        os_unfair_lock_unlock(&lock)

    }
    
}


// реализация на Objective-C
class SinhronizedObjct {
    private var lock = NSObject()
    
    var array = [Int]()
    
    func some() {
        objc_sync_enter(lock)
        array.append(1)
        objc_sync_exit(lock)
    }
    
}

