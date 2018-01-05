//
//  PostAddTableViewCell.swift
//  Walk2Deals
//
//  Created by Rama kuppa on 05/10/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class PostAddTableViewCell: UITableViewCell {

    @IBOutlet weak var postAddBtn: UIButton!
    @IBOutlet weak var postAddTextField: ACFloatingTextfield!
    override func awakeFromNib() {
        super.awakeFromNib()
        postAddTextField.placeHolderColor = CXAppConfig.sharedInstance.appColor()
        //8,128,124
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
