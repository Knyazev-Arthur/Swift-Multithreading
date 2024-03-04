import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true


// протокол CustomStringConvertible позволяет объектам иметь пользовательское описание, использующееся, например, при выводе объекта в консоль.
struct Document: CustomStringConvertible {
    let id: Int
    let name: String
    var description: String { "\(id) - \(name)" }
}

class DocumentStore: CustomStringConvertible {
    
    private var documents = [Document]() // хранилище документов
    private let syncQueue = DispatchQueue(label: "DocumentStoreSyncQueue", attributes: .concurrent) // глобальная параллельная очередь, используемая для синхронизации доступа к данным хранилища.

    func createDocument(name: String) {
        // флаг .barrier здесь предотвращает выполнение любых последующих операций до завершения блока кода, выполняемым в одном потоке
        syncQueue.async(flags: .barrier) {
            let lastId = self.documents.last?.id ?? 0 // получаем идентификатор последнего документа в хранилище
            let newId = lastId + 1 // Вычисляем новый идентификатор для текущего документа путем увеличения последнего идентификатора на 1.
            let doc = Document(id: newId, name: name) // создаем новый объект с вычисленным идентификатором и именем текущего символа.
            self.documents.append(doc)
        }
    }
    
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
    // опция group указывает, что задачи должны быть добавлены в ранее созданную группу group. DispatchGroup используется для ожидания завершения всех асинхронных задач, запущенных в цикле for
    DispatchQueue.global().async(group: group) {
        let docName = String(UnicodeScalar(charCode)!) // для каждого символа создается строка docName, представляющая символ
        documentStore.createDocument(name: docName)
    }
}

group.notify(queue: .main) {
    print(documentStore)
}
