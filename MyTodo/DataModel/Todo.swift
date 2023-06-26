//
//  Todo.swift
//  MyTodo
//
//  Created by Minh Tan Vu on 23/06/2023.
//

import Foundation
import RealmSwift

class Todo: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String?
    @Persisted var dateCreated: Date?
    @Persisted var isCompleted: Bool

    /**
     convenience là một hàm init phụ trợ. Chúng ta có thể sử lý logic đối với các hàm init convenience
     convenience: Cho phép ta gọi hàm khởi tạo khác của class
     example:
     convenience init(name: String, andAge age: Int) throws {
         if name.isEmpty {
             throw InvalidPersonError.EmptyName
         }
         
         if age < 0 {
             throw InvalidPersonError.InvalidAge
         }
         
         self.init(name: name, age: age)
     }
     */
    
    convenience init(title: String,dateCreated: Date, isCompleted: Bool) {
       self.init()
        self.title = title
        self.dateCreated = dateCreated
        self.isCompleted = isCompleted
   }
}
