//
//  HomeCollectionViewCell.swift
//  CoupoConHomeview
//
//  Created by Rama kuppa on 17/10/16.
//  Copyright © 2016 Mahesh. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var offerTitleLbl: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var favBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
