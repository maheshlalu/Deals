//
//  UserProfileTableViewCell.swift
//  Sample
//
//  Created by Manishi on 10/14/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class UserProfileTableViewCell: UITableViewCell {

  
    @IBOutlet weak var userProfileTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
