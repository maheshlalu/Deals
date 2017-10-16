//
//  PostAddViewController.swift
//  Walk2Deals
//
//  Created by Rama kuppa on 04/10/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class PostAddViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    let nameArray = ["Location","Category","Other Title","StartDate","EndDate","UploadImage"]
    
    @IBOutlet weak var postAddTableVIew: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        registrationCell()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func registrationCell(){
        
        let nib = UINib(nibName: "PostAddTableViewCell", bundle: nil)
        self.postAddTableVIew.register(nib, forCellReuseIdentifier: "PostAddTableViewCell")
        
        let nib1 = UINib(nibName: "PostAddOneTableViewCell", bundle: nil)
        self.postAddTableVIew.register(nib1, forCellReuseIdentifier: "PostAddOneTableViewCell")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostAddOneTableViewCell", for: indexPath)as? PostAddOneTableViewCell
            cell?.selectionStyle = .none
            return cell!
        }else{
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "PostAddTableViewCell", for: indexPath)as? PostAddTableViewCell
            if indexPath.row == 0{
                let tapgestures : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectLocation(_:)))
                tapgestures.numberOfTapsRequired = 1
                cell1?.postAddTextField.addGestureRecognizer(tapgestures)
                cell1?.postAddTextField.placeholder = "Location"
            }else if indexPath.row == 1{
                cell1?.postAddTextField.placeholder = "Category"
            }else if indexPath.row == 2{
                cell1?.postAddTextField.placeholder = "Other Title"
            }else if indexPath.row == 3{
                cell1?.postAddTextField.placeholder = "StartDate"
            }else if indexPath.row == 4{
                cell1?.postAddTextField.placeholder = "EndDate"
            }else if indexPath.row == 5{
                cell1?.postAddTextField.placeholder = "UploadImage"
            }
            cell1?.selectionStyle = .none
            return cell1!
        }
        /*
         
         else if indexPath.row == 1{
         
         let tapgestures : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectLocation(_:)))
         tapgestures.numberOfTapsRequired = 1
         cell1?.postAddTextField.addGestureRecognizer(tapgestures)
         
         cell1?.postAddTextField.placeholder = "Storename"
         }*/
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
    
    func selectLocation(_ sender: UITapGestureRecognizer){
        
       /* self.showPicker(title: "Select Member Type", rows: ["Doctor"], initialSelection: 0) { (value,index) in
            self.selectionDict["Member Type"] = value
            CXLog.print(value)
            CXLog.print(index)
        }*/
        
    }
    
    func showPicker(title:String,rows:[String],initialSelection:Int,completionPicking:@escaping (_ value:String,_ index:Int)->Void){
        
        ActionSheetStringPicker.show(withTitle: title, rows: rows, initialSelection: initialSelection, doneBlock: { ( picker, indexes, values) in
            if let key = values as? String {
                completionPicking(key,indexes)
            }
            
        }, cancel: { (picker) in
            
        }, origin: self.view)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4{
            return 100
            
        }else{
            
            return 53
            
        }
    }
    
    
    func postAddAction(){
        let parameters = ["OfferTitle":"","OfferDescription":"","StartDate":"","EndDate":"","UserId":"","IsActive":""]
        
        //yyyy-MM-dd HH:mm:ss.S
        
        
        /*
         {
         "OfferTitle": "sampledsfssdgfhfh789fsfringdsf2",
         "OfferDescription": "reste87fghfgh9sdfsdfrt",
         "StartDate": "2017-10-15T04:25:25.6619455-04:00",
         "EndDate": "2017-10-15T04:25:25.6619455-04:00",
         "UserId": 2,
         "DealCategories":[
         {
         
         "CategoryId": 6,
         
         }
         
         ],
         "DealLocations": [
         {
         "StoreLocationId": 1,
         "FileContentCoreEntityList": [
         {
         "FileName": "fdgdgfdg",
         "CDNFilePath": "dfgdfgdfg",
         "FileContent": "00000000000000000000000001100100"
         }
         
         ],     
         "IsActive": true,
         
         }
         }
        api/Deal/Save*/
        
    }
    
}


