//
//  StoreCreationViewController.swift
//  Walk2Deals
//
//  Created by Madhav Bhogapurapu on 11/7/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class StoreCreationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let dict = NSMutableDictionary()
    var placeHolderArr = NSArray()
    var labelNames = NSArray()
    var firstNameTxtField: UITextField!
    var lastNameTxtField: UITextField!
    var phoneNumberTxtField: UITextField!
    var emailTxtField: UITextField!
    var addressTxtField: UITextView!
    @IBOutlet var createBtn: UIButton!
    
    
    @IBOutlet var aTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeHolderArr = ["First Name","Last Name","Phone Number","Email Id"]
        labelNames = ["First Name","Last Name","Phone Number","Email Id",]
        
        
        self.aTableView.register(UINib(nibName:"PersonDetailsCell",bundle:nil), forCellReuseIdentifier: "PersonDetailsCell")
        self.aTableView.register(UINib(nibName:"AddressCell",bundle:nil), forCellReuseIdentifier: "AddressCell")
        //        self.aTableView.rowHeight = 70.0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return labelNames.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonDetailsCell", for: indexPath) as! PersonDetailsCell
            /*var nameArr: [String]
             var nameDetailArr: [String]
             nameArr = dict.allKeys as! [String]
             nameDetailArr = dict.allValues as! [String]
             cell.nameLbl.text = nameArr[indexPath.row]
             cell.nameDetailsLbl.text = nameDetailArr[indexPath.row]
             */
            if indexPath.row == 0 {
                firstNameTxtField = cell.nameDetails
            }else if indexPath.row == 1{
                lastNameTxtField = cell.nameDetails
            }else if indexPath.row == 2{
                phoneNumberTxtField = cell.nameDetails
            }else if indexPath.row == 3{
                emailTxtField = cell.nameDetails
            }
            
            cell.nameDetails.placeholder = placeHolderArr[indexPath.row] as! String
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressCell
            addressTxtField = cell.addressField
            addressTxtField.text = "Address"
            addressTxtField.textColor = UIColor.lightGray
            return cell
            //            cell.ChangeAddress.isHidden = false
            
        }
    }
    
    @IBAction func create_Btn_Action(_ sender: UIButton) {
        print(dict)
        if (firstNameTxtField.text?.isEmpty)! {
            alertMessage(alert: "Please Enter FirstName")
        }else{
            dict["FirstName"] = firstNameTxtField.text
        }
        if (lastNameTxtField.text?.isEmpty)! {
            alertMessage(alert: "Please Enter LastName")
        }else{
            dict["LastName"] = lastNameTxtField.text
        }
        if (emailTxtField.text?.isEmpty)! {
            alertMessage(alert: "Please Enter EmailId")
        }else{
            dict["Email"] = emailTxtField.text
        }
        if (phoneNumberTxtField.text?.isEmpty)! {
            alertMessage(alert: "Please Enter PhoneNuber")
        }else{
            dict["PhoneNumber"] = phoneNumberTxtField.text
        }
        if (addressTxtField.text?.isEmpty)! {
            alertMessage(alert: "Please Enter Your Address")
        }else{
            dict["Address"] = addressTxtField.text
        }
        print(dict)
    }
    func alertMessage(alert:String){
        let alert = UIAlertController(title: "oops", message: alert, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated:true, completion:nil)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50
        }else{
            return 100
        }
    }
}
