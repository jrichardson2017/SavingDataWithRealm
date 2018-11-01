//
//  PersonTableViewCell.swift
//  SavingData
//
//  Created by Justin Richardson on 2018-10-31.
//  Copyright © 2018 Justin Richardson. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    func configure(with person: Person) {
        nameLabel.text = person.name
        ageLabel.text = person.ageString() 
    }
    
}
