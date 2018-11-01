//
//  Person.swift
//  SavingData
//
//  Created by Justin Richardson on 2018-10-31.
//  Copyright © 2018 Justin Richardson. All rights reserved.
//

import UIKit
import RealmSwift

class Person: Object {
    
    // Realm objects need to be dynmic so they are available at run time
    @objc dynamic var name: String = ""
    let age = RealmOptional<Int>()
    
    convenience init(name: String, age: Int?) {
        self.init()
        self.name = name
        self.age.value = age
    }
    
    func ageString() -> String {
        guard let age = self.age.value else { return "" }
        return String(age)
    }
    
}
