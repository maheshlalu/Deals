//
//  PostAddViewController.swift
//  Walk2Deals
//
//  Created by Rama kuppa on 04/10/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import SwiftyJSON
class PostAddViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    let nameArray = ["Stores","Location","Category","Other Title","StartDate","EndDate","UploadImage"]
    
    var selectedStore = NSDictionary()
    var selectedLocation = NSDictionary()
    
    var selectedLocationArray = NSArray()
    var selectedStoresArray = NSArray()
    
    var locations: NSArray!
    var selectionDict : NSMutableDictionary = NSMutableDictionary()
    @IBOutlet weak var postAddTableVIew: UITableView!
     var DropDownList : DropDownListView!
    override func viewDidLoad() {
        super.viewDidLoad()
        registrationCell()
        self.getAllStoreLocations()
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
        /*
         1.Get Stores : http://api.walk2deals.com/api/Store/GetAll
         2.Get locations based on stores : http://api.walk2deals.com/api/Store/GetAllStoreLocationbyId/3
         3.Get all  category  : http://api.walk2deals.com/api/Category/GetAll
         */
        
        CXDataService.sharedInstance.getTheDataFromServer(urlString: "http://api.walk2deals.com/api/Store/GetAll") { (responceDict) in
            if let stores = responceDict.value(forKey: "Stores") as? NSArray{
                self.selectedStoresArray = stores
                self.selectedStore = (self.selectedStoresArray.firstObject as? NSDictionary)!
                self.getLocationBasedOnStores()
            }
            CXLog.print(responceDict)
            
            //Stores
        }
        
    }
    
    func getLocationBasedOnStores(){
        
        let json = JSON(self.selectedStore)
        let urlString = "http://api.walk2deals.com/api/Store/GetAllStoreLocationbyId/" + json["Id"].string!
        CXDataService.sharedInstance.getTheDataFromServer(urlString: urlString) { (responceDict) in
            CXLog.print(responceDict)
            self.selectedLocationArray = JSON(responceDict)["StoreLocations"].array! as NSArray
            self.selectedLocation = (self.selectedLocationArray.firstObject as? NSDictionary)!
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "PostAddTableViewCell", for: indexPath)as? PostAddTableViewCell
        let itemName = self.nameArray[indexPath.row]
        
        if itemName == "Stores" {
            
        }else if itemName == "Location"{
            let tapgestures : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectLocation(_:)))
            tapgestures.numberOfTapsRequired = 1
            cell1?.postAddTextField.addGestureRecognizer(tapgestures)
            cell1?.postAddTextField.placeholder = "Location"
            if let name = self.selectionDict["Location"] as? String{
                cell1?.postAddTextField?.text = name
            }
        }else if itemName == "Category"{
            cell1?.postAddTextField.placeholder = "Category"
            let tapgestures : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectCategory(_:)))
            tapgestures.numberOfTapsRequired = 1
            cell1?.postAddTextField.addGestureRecognizer(tapgestures)
        }else if itemName == "Other Title"{
            cell1?.postAddTextField.placeholder = "Other Title"
        }else if itemName == "StartDate"{
            cell1?.postAddTextField.placeholder = "StartDate"
        }else if itemName == "EndDate"{
            cell1?.postAddTextField.placeholder = "EndDate"
        }else if itemName == "UploadImage"{
            cell1?.postAddTextField.placeholder = "UploadImage"
        }
        cell1?.selectionStyle = .none
        return cell1!
        
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
        
        /*
        DealCoreEntity =  {
         "OfferTitle": "test",
         "OfferDescription": "test",
         "StartDate": "2017-9-17",
         "EndDate": "2017-9-28",
         "UserId": 18,
         "DealCategories": [
         {
         "CategoryId": 1
         }
         ],
         "DealLocations": [
         {
         "StoreLocationId": 2,
         "isActive": true
         }
         ]
         }
         2= "file"
         api/Deal/Save*/
        let array = [dict]
        mainDict["DealCategories"] = array

        let subDict = NSMutableDictionary()
        subDict["StoreLocationId"] = "1"
        subDict["IsActive"] = "true"
        let arr = [subDict]
        mainDict["DealLocations"] = arr
        
        print(mainDict)
        
        let inputDic = ["DealCoreEntity":self.constructTheJson(ticketsInput: mainDict),"2":""]
        
        CXDataService.sharedInstance.postTheDataToServer(urlString: CXAppConfig.sharedInstance.getBaseUrl()+"api/Deal/Save", parameters: inputDic as! [String : String]) { (responceDic) in
            CXLog.print("responce dict \(responceDic)")
            
            let error = responceDic.value(forKey: "Errors") as? NSArray
            let errorDict = error?.lastObject as? NSDictionary
            let errorcode = errorDict?.value(forKey: "ErrorCode") as? String
            if errorcode == "0"{
               
            }else{
                CXDataService.sharedInstance.showAlert(message: "Something went Wrong!!!", viewController: self)
            }
            
        }
        
       
        
    }
    
    func constructTheJson(ticketsInput:NSMutableDictionary) -> String{
        
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
