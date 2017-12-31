//
//  DealTitleCell.swift
//  Walk2Deals
//
//  Created by Madhav Bhogapurapu on 11/6/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class DealTitleCell: UITableViewCell {

    @IBOutlet var dealTitleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
