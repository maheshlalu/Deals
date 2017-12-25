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
    @IBOutlet weak var distanceLbl: UILabel!

    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var favBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // self.backgroundColor = UIColor.red
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(10, 10, 10, 10))
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
