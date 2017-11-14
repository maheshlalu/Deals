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

    @IBOutlet weak var streetAddressTextView: UITextView!
    @IBOutlet weak var parkingTextView: UITextView!
    @IBOutlet weak var rampTextView: UITextView!
    @IBOutlet weak var constructionTextView: UITextView!
    @IBOutlet weak var managementTextView: UITextView!
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var favourateTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
