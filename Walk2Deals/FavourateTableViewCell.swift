//
//  FavourateTableViewCell.swift
//  BaluProject
//
//  Created by Rama kuppa on 29/09/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class FavourateTableViewCell: UITableViewCell {
    @IBOutlet weak var favourateLabel: UILabel!

    @IBOutlet weak var name: UITextView!
    @IBOutlet weak var contactName: UITextView!
    @IBOutlet weak var phoneNumber: UITextView!
    @IBOutlet weak var anotherNumber: UITextView!
    @IBOutlet weak var email: UITextView!
    @IBOutlet weak var address: UITextView!

    @IBOutlet weak var chageAddressAction: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
