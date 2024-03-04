import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

//let dwi1 = DispatchWorkItem {
//    print("a")
//    sleep(5)
//}
//
//let dwi2 = DispatchWorkItem {
//    print("c")
//}
//
//DispatchQueue.global().async(execute: dwi1)
//dwi1.notify(queue: .main, execute: dwi2)
//dwi1.notify(queue: .main) { print("A will be done") }

//dwi1.cancel() // DispatchWorkItem может быть отменен, если еще не начал выполнять операцию


//var a = 0
//
//let dwi1 = DispatchWorkItem { a += 1 }
//let dwi2 = DispatchWorkItem { print(a) }
//
//DispatchQueue.global().async(execute: dwi1)
////DispatchQueue.global().async(execute: dwi2)
//
//dwi1.notify(queue: .main, execute: dwi2)

//let dwi1 = DispatchWorkItem {
//    sleep(10)
//    print("a")
//}
//DispatchQueue.global().async(execute: dwi1)
//
//dwi1.wait(timeout: .now() + 2) // wait не пропустит выполнение кода дальше, пока не выполнится dwi1
//
//print("b")
//
//let setInt = Set(1...100)
//var setString = Set<String>()
//let group = DispatchGroup()
//
//setInt.forEach { element in
//    DispatchQueue.global().async(group: group) {
//        sleep(1)
//        setString.insert("Строка # \(element)")
//    }
//}
//
//group.wait()
//print(setString)

//let setString2 = Set<String>(setInt.map {
//    sleep(1)
//    return "Строка # " + String($0)
//})

//struct Document: CustomStringConvertible {
//
//    let id: Int
//    let name: String
//
//    var description: String { "\(id) - \(name)" }
//}
//
//var documents = [Document]()
//let firstChar = UnicodeScalar("А").value
//let lastChar = UnicodeScalar("Я").value
//let group = DispatchGroup()
//
//for charCode in firstChar...lastChar {
//    DispatchQueue.global().async(group: group) {
//        let docName = String(UnicodeScalar(charCode)!)
//        let lastId = documents.last?.id ?? 0
//        let newId = lastId + 1
//        let doc = Document(id: newId, name: docName)
//        documents.append(doc)
//    }
//}
//
//group.notify(queue: .main) { print(documents) }

// CustomStringConvertible протокол позволяет объектам иметь пользовательское описание, которое используется, например, при выводе объекта в консоль.
struct Document: CustomStringConvertible {

    let id: Int
    let name: String

    var description: String { "\(id) - \(name)" }
}

class DocumentStore: CustomStringConvertible {
    
    private var documents = [Document]() // хранилище документов
    private let syncQueue = DispatchQueue(label: "DocumentStoreSyncQueue", attributes: .concurrent) // глобальная параллельная очередь, используемая для синхронизации доступа к данным хранилища.
    
//    func getDocument(id: Int) -> Document? { // метод, возвращающий док по идентификатору
//        var document: Document?
//        syncQueue.async { // асинхронное выполнение блока кода на очереди syncQueue обеспечивает безопасный доступ для чтения к массиву documents из нескольких потоков.
//            if let index = self.documents.firstIndex(where: { $0.id == id }) { // firstIndex: метод массива, который возвращает индекс первого элемента, удовлетворяющего условию, заданному замыканием.
//                document = self.documents[index] // Если индекс элемента найден присваиваем элемент массива с найденным индексом перем-ой document
//            }
//        }
//        return document
//    }
    
    func createDocument(name: String) {
        // флаг .barrier гарантирует выполнение блока кода после всех предыдущих операций, а также предотвращает выполнение любых последующих операций до его завершения.
        syncQueue.async(flags: .barrier) {
            let lastId = self.documents.last?.id ?? 0 // получаем идентификатор последнего документа в хранилище
            let newId = lastId + 1 // Вычисляем новый идентификатор для текущего документа путем увеличения последнего идентификатора на 1.
            let doc = Document(id: newId, name: name) // Создается новый объект Document с вычисленным идентификатором и именем текущего символа.
            self.documents.append(doc)
        }
    }
    
//    func getLastDocument() -> Document? {
//        var document: Document?
//        syncQueue.async { document = self.documents.last } // асинхронно (для безопасного выполнения из нескольких потоков) присваиваем последний элемент массива
//        return document
//    }
//
//    func app(document: Document) {
//        // флаг .barrier гарантирует выполнение блока кода после всех предыдущих операций, а также предотвращает выполнение любых последующих операций до его завершения.
//        syncQueue.async(flags: .barrier) {
//            self.documents.append(document)
//        }
//    }
    
    var description: String {
        var description = ""
        syncQueue.sync {
            description = self.documents.reduce("") { $0 + $1.description + ", " }  // используем метод массива reduce, чтобы объединить описания всех документов в хранилище в одну строку. $0 - накопитель, а $1 - текущий элемент массива
        }
        return description
    }
    
}

var documentStore = DocumentStore()
let firstChar = UnicodeScalar("А").value
let lastChar = UnicodeScalar("Я").value
let group = DispatchGroup()

for charCode in firstChar...lastChar {
    DispatchQueue.global().async(group: group) {
        let docName = String(UnicodeScalar(charCode)!) // для каждого символа создается строка docName, представляющая символ
        documentStore.createDocument(name: docName)
//        let lastId = documentStore.getLastDocument()?.id ?? 0 // получаем идентификатор последнего документа в хранилище
//        let newId = lastId + 1 // Вычисляем новый идентификатор для текущего документа путем увеличения последнего идентификатора на 1.
//        let doc = Document(id: newId, name: docName) // Создается новый объект Document с вычисленным идентификатором и именем текущего символа.
//        documentStore.app(document: doc)
    }
}

group.notify(queue: .main) { print(documentStore) }
