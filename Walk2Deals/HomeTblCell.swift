//
//  HomeTblCell.swift
//  Walk2Deals
//
//  Created by Rama on 12/17/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class HomeTblCell: UITableViewCell {

    @IBOutlet weak var dealImgView: UIImageView!
    @IBOutlet weak var dealTitleLbl: UILabel!
    @IBOutlet weak var dealSubTitleLbl: UILabel!
    @IBOutlet weak var optionBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
