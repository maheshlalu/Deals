//
//  UserProfileTableViewCell.swift
//  Sample
//
//  Created by Manishi on 10/14/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class UserProfileTableViewCell: UITableViewCell {

  
    @IBOutlet weak var userProfileTextField: ACFloatingTextfield!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userProfileTextField.placeHolderColor = CXAppConfig.sharedInstance.appColor()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

/*
 1. Page Dots color codes —
 2. unlike in home page
 
 Detail Page
 
 1. exp date in detail page
 2. add review button i detail page
 3. include contact number and StoreLocationName in detail page address
 4. update the review in Detail page
 5. review count display in detail page
 DealReviewStars = “3.5/5“;
 8.tabbar font in detail page
 9.Like delegate implementation
 
 
 SideMenu
 1.Edit profile align
 2.Add Role in Request for ad
 3.Circle in Near by store
 4.Add description in popUp
 5. add Change password option
 
 Post Ad
 Design Change in PostAd
 post Add issue while uploading

 */
