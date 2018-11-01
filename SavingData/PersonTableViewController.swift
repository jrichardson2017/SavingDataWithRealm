//
//  PersonTableViewController.swift
//  SavingData
//
//  Created by Justin Richardson on 2018-10-10.
//  Copyright © 2018 Justin Richardson. All rights reserved.
//

import UIKit
import RealmSwift 

class PersonTableViewController: UITableViewController {
    
    // MARK: - Variables
    var people: Results<Person>!
    var notificationToken: NotificationToken?
    
    // MARK: - Outlets
    

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60
        setNavbarAppearance()
        
        RealmService.shared.observeRealmErrors(in: self) { (error) in
            print(error ?? "No errors detected")
        }
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        let realm = RealmService.shared.realm
//        people = realm.objects(Person.self)
//        notificationToken = realm.observe { (notification, realm) in
//            self.tableView.reloadData()
//        }
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // when unwind is used, realm.observe no longer works :(
//        notificationToken?.invalidate()
        RealmService.shared.stopObservingErrors(in: self)
    }

    // MARK: - Actions
    @IBAction func onPlusTapped() {
        let alert = createAlert(title: "Add Person")
        let action = createAction(for: alert, title: "Add")
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func unwindOnUpdateTapped(_ sender: UIStoryboardSegue) {
        guard let detailViewController = sender.source as? DetailViewController else { return }
        detailViewController.updateTapped()
        
        guard let indexPath = detailViewController.indexPath else { return }
        
        if let name = detailViewController.name, let ageString = detailViewController.age {
            guard let age = Int(ageString) else { return }
            let person = people[indexPath.row]
            let dictionary: [String: Any?] = ["name": name, "age": age]
            RealmService.shared.update(person, with: dictionary)
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Functions
    func createAlert(title: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
            textField.autocapitalizationType = .words
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Age"
            textField.keyboardType = .numberPad
        }
        return alert
    }
    
    func createAction(for alert: UIAlertController, title: String) -> UIAlertAction {
        let action = UIAlertAction(title: title, style: .default) { [weak self] (_) in
            guard let name = alert.textFields?.first?.text else { return }
            guard let age = alert.textFields?.last?.text else { return }
            
            let person = Person(name: name, age: Int(age))
            RealmService.shared.create(person)
            
            self?.tableView.reloadData()
        }
        return action
    }
    
    func setNavbarAppearance() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "People"
    }
    
}

extension PersonTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as? PersonTableViewCell
        let backupCell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let person = people[indexPath.row]
        cell?.configure(with: person)
        return cell ?? backupCell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let person = people[indexPath.row]
        print("'\(person)' being deleted from \([indexPath.row])")
        RealmService.shared.delete(person)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailViewController = segue.destination as? DetailViewController else { return }
        guard let cell = sender as? UITableViewCell else { return }
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        detailViewController.name = people[indexPath.row].name
        detailViewController.age = people[indexPath.row].ageString()
        detailViewController.indexPath = indexPath
    }
    
}
