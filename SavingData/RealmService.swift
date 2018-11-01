//
//  RealmService.swift
//  SavingData
//
//  Created by Justin Richardson on 2018-10-31.
//  Copyright © 2018 Justin Richardson. All rights reserved.
//

import UIKit
import RealmSwift

class RealmService {
    
    // Make class private so you can create instances of it
    private init() {}
    
    // Make a singleton so we always reference the same instance of our Realm object
    static let shared = RealmService()
    
    // A Realm object is a pointer to a Realm file in the documents directory of the app
    var realm = try! Realm()
    
    // CRUD Functions
    func create<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            post(error)
        }
    }
    
    func update<T: Object>(_ object: T, with dictionay: [String:Any?] ) {
        do {
            try realm.write {
                for (key, value) in dictionay {
                    object.setValue(value, forKey: key)
                }
            }
        } catch {
            post(error)
        }
    }
    
    func delete<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            post(error)
        }
    }
    
    // MARK: Extra for error handling
    func post(_ error: Error) {
        NotificationCenter.default.post(name: NSNotification.Name("RealmError"), object: error)
    }
    
    func observeRealmErrors(in vc: UIViewController, completion: @escaping (Error?) -> Void) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("RealmError"), object: nil, queue: nil) { (notification) in
            completion(notification.object as? Error)
        }
    }
    
    func stopObservingErrors(in vc: UIViewController) {
        NotificationCenter.default.removeObserver(vc, name: NSNotification.Name("RealmError"), object: nil)
    }
    
}
