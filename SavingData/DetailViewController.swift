//
//  DetailViewController.swift
//  SavingData
//
//  Created by Justin Richardson on 2018-10-31.
//  Copyright © 2018 Justin Richardson. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Variables
    var name: String?
    var age: String?
    var indexPath: IndexPath?
    
    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = name
        ageTextField.text = age
    }
    
    // MARK: - Functions
    func updateTapped() {
        name = nameTextField.text
        age = ageTextField.text
    }

}
