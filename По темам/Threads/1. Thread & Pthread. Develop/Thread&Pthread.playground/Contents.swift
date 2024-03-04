import UIKit

var thread = pthread_t(bitPattern: 0) // создаем поток
var atribut = pthread_attr_t()

pthread_attr_init(&atribut)
pthread_create(&thread, &atribut, { _ -> UnsafeMutableRawPointer? in
    print("Тест")
    return nil
}, nil)
