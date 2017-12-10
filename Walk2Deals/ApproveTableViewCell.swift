//
//  ApproveTableViewCell.swift
//  Walk2Deals
//
//  Created by Rama kuppa on 09/12/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class ApproveTableViewCell: UITableViewCell {
    @IBOutlet weak var userImgView: UIImageView!
    
    @IBOutlet weak var couponCodeLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    
    @IBOutlet weak var approveBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userImgView.layer.cornerRadius = 38
        self.userImgView.layer.borderColor = UIColor.white.cgColor
        self.userImgView.layer.masksToBounds = true
        
        self.approveBtn.layer.cornerRadius = 8
        self.approveBtn.layer.borderColor = UIColor.white.cgColor
        self.approveBtn.layer.masksToBounds = true
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
