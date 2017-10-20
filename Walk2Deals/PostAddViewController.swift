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
    
    var locations: NSArray!
    var selectionDict : NSMutableDictionary = NSMutableDictionary()
    @IBOutlet weak var postAddTableVIew: UITableView!
     var DropDownList : DropDownListView!
    override func viewDidLoad() {
        super.viewDidLoad()
        registrationCell()
        //self.postAddAction()
        // Do any additional setup after loading the view.
    }
    
    func registrationCell(){
        
        let nib = UINib(nibName: "PostAddTableViewCell", bundle: nil)
        self.postAddTableVIew.register(nib, forCellReuseIdentifier: "PostAddTableViewCell")
        
        let nib1 = UINib(nibName: "PostAddOneTableViewCell", bundle: nil)
        self.postAddTableVIew.register(nib1, forCellReuseIdentifier: "PostAddOneTableViewCell")
        
    }
    
    func getAllStoreLocations(){
        //api/Store/GetAllStoreLocation/{UserId}-
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
                
                if let name = self.selectionDict["Location"] as? String{
                    cell1?.postAddTextField?.text = name
                }
                
            }else if indexPath.row == 1{
                cell1?.postAddTextField.placeholder = "Category"
                let tapgestures : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectCategory(_:)))
                tapgestures.numberOfTapsRequired = 1
                cell1?.postAddTextField.addGestureRecognizer(tapgestures)
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
        
       self.showPicker(title: "Select Location", rows: ["Vskp","Sklm","Test"], initialSelection: 0) { (value,index) in
            self.selectionDict["LocationName"] = value
            CXLog.print(value)
            CXLog.print(index)
        }
        
    }
    
    func selectCategory(_ sender: UITapGestureRecognizer){
        
        
       // let touchLocation: CGPoint = CGPoint(x: self.view.frame.size.width/2, y: <#T##CGFloat#>)
        if DropDownList != nil {
           DropDownList.fadeOut()
        }
        //DropDownList.fadeOut()
        DropDownList  = DropDownListView(title: "", options: ["heloo","test","tewerwer","ew52145"], xy: self.view.center, size: CGSize(width: 300, height: 320), isMultiple: true)
        DropDownList.delegate = self
        DropDownList.center = self.view.center
        DropDownList.show(in: self.view, animated: true)
        DropDownList.setBackGroundDropDown_R(23.0, g: 56.0, b: 32.0, alpha: 1.0)
        //DropDownList.fadeOut()
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
            return 75
            
        }
    }
    
    
    func postAddAction(){
        let parameters = ["OfferTitle":"","OfferDescription":"","StartDate":"","EndDate":"","UserId":"","IsActive":""]
        
        //yyyy-MM-dd HH:mm:ss.S
        
        let image = UIImage(named: "images")
       let imageData: NSData = UIImagePNGRepresentation(image!) as! NSData
        
        let mainDict = NSMutableDictionary()
        mainDict["OfferTitle"] = "Diwali special offer"
        mainDict["OfferDescription"] = "reste87fghfgh9sdfsdfrt"
        mainDict["StartDate"] = "2017-10-15T04:25:25.6619455-04:00"
        mainDict["EndDate"] = "2017-20-15T04:25:25.6619455-04:00"
        mainDict["UserId"] = "2"
        let dict = ["CategoryId":"1"]
        let array = [dict]
        mainDict["DealCategories"] = self.constructTheJson(ticketsInput: array as! NSMutableArray)
        let dict1 = ["FileName":"fdgdgfdg",
                     "CDNFilePath":"dfgdfgdfg",
                     "FileContent":imageData] as [String : Any]
        let array1 = [dict1]
        let subDict = NSMutableDictionary()
        subDict["StoreLocationId"] = "1"
        subDict["FileContentCoreEntityList"] = self.constructTheJson(ticketsInput: array1 as! NSMutableArray)
        subDict["IsActive"] = "true"
        let arr = [subDict]
        mainDict["DealLocations"] = arr
        
        print(mainDict)
        
        
        CXDataService.sharedInstance.postTheDataToServer(urlString: CXAppConfig.sharedInstance.getBaseUrl()+"api/Deal/Save", parameters: mainDict as! [String : String]) { (responceDic) in
            CXLog.print("responce dict \(responceDic)")
            
            let error = responceDic.value(forKey: "Errors") as? NSArray
            let errorDict = error?.lastObject as? NSDictionary
            let errorcode = errorDict?.value(forKey: "ErrorCode") as? String
            if errorcode == "0"{
               
            }else{
                CXDataService.sharedInstance.showAlert(message: "Something went Wrong!!!", viewController: self)
            }
            
        }
        
        /*
         {
         "OfferTitle": "sampledsfssdgfhfh789fsfringdsf2",
         "OfferDescription": "reste87fghfgh9sdfsdfrt",
         "StartDate": "2017-10-15T04:25:25.6619455-04:00",
         "EndDate": "2017-10-15T04:25:25.6619455-04:00",
         "UserId": 2,
         "IsActive": true,

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
         
         }]
         }
        api/Deal/Save*/
        
    }
    
    func constructTheJson(ticketsInput:NSMutableArray) -> String{
        
        var jsonData : Data = Data()
        do {
            jsonData = try JSONSerialization.data(withJSONObject: ticketsInput, options: JSONSerialization.WritingOptions.prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
        } catch let error as NSError {
        }
        let jsonStringFormat = String(data: jsonData, encoding: String.Encoding.utf8)
        
        return jsonStringFormat!
    }
    
}

extension PostAddViewController: kDropDownListViewDelegate{
    /*
     - (void)DropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex;
     - (void)DropDownListView:(DropDownListView *)dropdownListView Datalist:(NSMutableArray*)ArryData;
     - (void)DropDownListViewDidCancel;
     */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    func dropDownListViewDidCancel() {
        
    }
    
    func dropDownListView(_ dropdownListView: DropDownListView!, didSelectedIndex anIndex: Int) {
        
    }
    
    func dropDownListView(_ dropdownListView: DropDownListView!, datalist ArryData: NSMutableArray!) {
        
    }
    
}
