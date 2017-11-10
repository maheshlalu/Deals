//
//  PersonDetailsCell.swift
//  RegistrationScreenWithDictionaries
//
//  Created by GOPINADH on 07/11/17.
//  Copyright © 2017 GOPINADH. All rights reserved.
//

import UIKit

class PersonDetailsCell: UITableViewCell,UITextFieldDelegate {
    
    @IBOutlet var nameDetails: UITextField!
    
    @IBOutlet var ChangeAddress: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameDetails.delegate = self
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameDetails.resignFirstResponder()
        return true
    }
   
    
}
