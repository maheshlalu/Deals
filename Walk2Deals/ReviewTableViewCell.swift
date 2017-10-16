//
//  ReviewTableViewCell.swift
//  Walk2Deals
//
//  Created by apple on 13/10/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    @IBOutlet weak var userImg: UIImageView!

    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var reviewTxtLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
