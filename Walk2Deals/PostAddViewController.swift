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
import Alamofire
class PostAddViewController: UIViewController,UITableViewDelegate,UITableViewDataSource ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    @IBOutlet weak var uploadImgview: UIImageView!
    let nameArray = ["Stores","Location","Category","Offer  Title","Description","StartDate","EndDate"]//"Upload"
    
    var selectedStore = NSDictionary()
    var selectedLocation = NSDictionary()
    
    var selectedLocationArray = NSArray()
    var selectedStoresArray = NSArray()
    
    var categoriesArray = NSArray()
    var selectedCategories = NSMutableArray()
    var selectedCategoriesNames = [String]()
    
    
    var locations: NSArray!
    var selectionDict : NSMutableDictionary = NSMutableDictionary()
    
    var imag : UIImage!
    @IBOutlet weak var postAddTableVIew: UITableView!
    
    var startDate = Date()
    var endDate = Date()
    
    var startDateStr = ""
    var endDateStr = ""
    
    
    var isSelectDate = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpBackButton()
        registrationCell()
        self.getAllStoreLocations()
        self.getAllCategories()
        //self.postAddAction()
        // Do any additional setup after loading the view.
    }
    
    func registrationCell(){
        
        let nib = UINib(nibName: "PostAddTableViewCell", bundle: nil)
        self.postAddTableVIew.register(nib, forCellReuseIdentifier: "PostAddTableViewCell")
        
        let nib1 = UINib(nibName: "PostAddOneTableViewCell", bundle: nil)
        self.postAddTableVIew.register(nib1, forCellReuseIdentifier: "PostAddOneTableViewCell")
        
    }
    
    func setUpBackButton(){
        self.title = "Post Ad"
        let menuItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(SettingsViewController.backAction(sender:)))
        self.navigationItem.leftBarButtonItem = menuItem
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }
    
    
    func backAction(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true) {
            
        }
    }
    
    //MARK: Get locations
    
    func getAllStoreLocations(){
        //api/Store/GetAllStoreLocation/{UserId}-
        /*
         1.Get Stores : http://api.walk2deals.com/api/Store/GetAll
         2.Get locations based on stores : http://api.walk2deals.com/api/Store/GetAllStoreLocationbyId/3
         3.Get all  category  : http://api.walk2deals.com/api/Category/GetAll
         
         
         http://api.walk2deals.com/api/Store/StoreLocationbyUser/userid/storeid
         
         
         http://api.walk2deals.com/api/Store/StorebyUser/userId
         
         
         */
        
        let user = CXDataSaveManager.sharedInstance.getTheUserProfileFromDB()
        
        CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading...")
        CXDataService.sharedInstance.getTheDataFromServer(urlString: "http://api.walk2deals.com/api/Store/StorebyUser/" + user.userId) { (responceDict) in
            if let stores = responceDict.value(forKey: "Stores") as? NSArray{
                self.selectedStoresArray = stores
                self.selectedStore = (self.selectedStoresArray.firstObject as? NSDictionary)!
                CXDataService.sharedInstance.hideLoader()
                self.getLocationBasedOnStores()
            }
            CXLog.print(responceDict)
            
            //Stores
        }
        
    }
    
    func getAllCategories(){
        //CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading...")
        CXDataService.sharedInstance.getTheDataFromServer(urlString: "http://api.walk2deals.com/api/Category/GetAll") { (responceDict) in
            if let stores = responceDict.value(forKey: "Categories") as? NSArray{
                self.categoriesArray = stores
                // self.selectedStore = (self.selectedStoresArray.firstObject as? NSDictionary)!
                for store in self.categoriesArray {
                    let storeDict = store as? NSDictionary
                    if let locName = storeDict?.value(forKey: "Name") as? String{
                        self.selectedCategoriesNames.append(locName)
                    }else{
                        self.selectedCategoriesNames.append("Empty")
                    }
                }
                // CXDataService.sharedInstance.hideLoader()
            }
            CXLog.print(responceDict)
            
            //Stores
        }
    }
    
    func getLocationBasedOnStores(){
        let user = CXDataSaveManager.sharedInstance.getTheUserProfileFromDB()

        //http://api.walk2deals.com/api/Store/StoreLocationbyUser/userid/storeid
        CXDataService.sharedInstance.showLoader(view: self.view, message: "Loading...")
        let storeID = CXAppConfig.resultString(self.selectedStore.value(forKey: "StoreId") as AnyObject)
        let urlString = "http://api.walk2deals.com/api/Store/StoreLocationbyUser/"+"\(user.userId)/" + storeID
        CXDataService.sharedInstance.getTheDataFromServer(urlString: urlString) { (responceDict) in
            self.selectedLocationArray = responceDict.value(forKey: "StoreLocations")  as! NSArray
            self.selectedLocation = (self.selectedLocationArray.firstObject as? NSDictionary)!
            self.reloadIndex(indexs: [IndexPath(row: 0, section: 0),IndexPath(row: 1, section: 0)])
            CXDataService.sharedInstance.hideLoader()
            
        }
        
        /*
         StoreLocations =     (
         {
         StoreId = 1;
         StoreLocationId = 1;
         StoreLocationName = "Pm Palem";
         StoreName = "D-Mart";
         }
         );
         */
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "PostAddTableViewCell", for: indexPath)as? PostAddTableViewCell
        let itemName = self.nameArray[indexPath.row]
        
        if itemName == "Stores" {
            let tapgestures : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectStores(_:)))
            tapgestures.numberOfTapsRequired = 1
            cell1?.postAddTextField.placeholder = "Store"
            cell1?.postAddTextField.addGestureRecognizer(tapgestures)
            if let name = self.selectedStore.value(forKey: "StoreName") as? String{
                cell1?.postAddTextField?.text = name
            }else{
                cell1?.postAddTextField?.text = ""
            }
        }else if itemName == "Location"{
            let tapgestures : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectLocation(_:)))
            tapgestures.numberOfTapsRequired = 1
            cell1?.postAddTextField.addGestureRecognizer(tapgestures)
            cell1?.postAddTextField.placeholder = "Location"
            if let name = self.selectedLocation.value(forKey: "StoreLocationName") as? String{
                cell1?.postAddTextField?.text = name
            }else{
                cell1?.postAddTextField?.text = ""
            }
        }else if itemName == "Category"{
            cell1?.postAddTextField.placeholder = "Category"
            let tapgestures : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectCategory(_:)))
            tapgestures.numberOfTapsRequired = 1
            cell1?.postAddTextField.addGestureRecognizer(tapgestures)
            var catNames = ""
            for cateDic in self.selectedCategories {
                let dict = cateDic as? NSDictionary
                if let locName = dict?.value(forKey: "Name") as? String{
                    if catNames.isEmpty {
                        catNames = catNames  + locName
                        
                    }else{
                        catNames = catNames + "," + locName
                        
                    }
                }else{
                }
            }
            cell1?.postAddTextField.text = catNames
            
        }else if itemName == "Offer  Title"{
            cell1?.postAddBtn.isHidden = true
            cell1?.postAddTextField.placeholder = "Offer  Title"
        }else if itemName == "StartDate"{
            let tapgestures : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(startDateSelection(_:)))
            tapgestures.numberOfTapsRequired = 1
            cell1?.postAddTextField.placeholder = "StartDate"
            
            if self.startDateStr.isEmpty {
                cell1?.postAddTextField.text = ""
                
            }else{
                cell1?.postAddTextField.text = self.startDateStr
                
            }
            
            cell1?.postAddTextField.addGestureRecognizer(tapgestures)
        }else if itemName == "EndDate"{
            let tapgestures : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(endDateSelection(_:)))
            tapgestures.numberOfTapsRequired = 1
            cell1?.postAddTextField.placeholder = "EndDate"
            cell1?.postAddTextField.addGestureRecognizer(tapgestures)
            
            if self.endDateStr.isEmpty {
                cell1?.postAddTextField.text = ""
            }else{
                cell1?.postAddTextField.text = self.endDateStr
            }
            
        }else if itemName == "UploadImage"{
            cell1?.postAddTextField.placeholder = "UploadImage"
        }else if itemName == "Description"{
            //let cell = tableView.dequeueReusableCell(withIdentifier: "PostAddOneTableViewCell", for: indexPath)as? PostAddOneTableViewCell
            cell1?.postAddTextField.placeholder = "Description"
            cell1?.postAddBtn.isHidden = true
        }else if itemName == "Upload"{
             let cell = tableView.dequeueReusableCell(withIdentifier: "PostAddOneTableViewCell", for: indexPath)as? PostAddOneTableViewCell
            if let img = self.imag {
                cell?.addImgView.image = img
            }
            cell?.uploadBtn.addTarget(self, action:#selector(addImgeUpload(sender:)), for: .touchUpInside)
            cell?.selectionStyle = .none
            return cell!
        }
        cell1?.selectionStyle = .none
        return cell1!

    }
    
    

    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
    //MARK: Select Stores
    
    func selectStores(_ sender: UITapGestureRecognizer){
        //StoreName
        
        var storeNameDic = [String]()
        for store in self.selectedStoresArray {
            let storeDict = store as? NSDictionary
            storeNameDic.append(storeDict?.value(forKey: "StoreName") as! String)
        }
        self.showPicker(title: "Select Store", rows: storeNameDic, initialSelection: 0) { (value,index) in
            self.selectedStore = self.selectedStoresArray[index] as! NSDictionary
            self.reloadIndex(indexs: [IndexPath(row: 0, section: 0),IndexPath(row: 1, section: 0)])
            self.getLocationBasedOnStores()
            CXLog.print(value)
            CXLog.print(index)
        }
    }
    
    func reloadIndex(indexs:[IndexPath]){
        //self.selectedLocation = NSDictionary()
        self.postAddTableVIew.reloadRows(at: indexs, with: .none)
    }
    
    func selectLocation(_ sender: UITapGestureRecognizer){
        
        var storeNameDic = [String]()
        for store in self.selectedLocationArray {
            let storeDict = store as? NSDictionary
            if let locName = storeDict?.value(forKey: "StoreLocationName") as? String{
                storeNameDic.append(locName)
            }else{
                storeNameDic.append("Empty")
            }
        }
        self.showPicker(title: "Select Location", rows: storeNameDic, initialSelection: 0) { (value,index) in
            self.selectedLocation = self.selectedLocationArray[index] as! NSDictionary
            self.postAddTableVIew.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
            CXLog.print(value)
            CXLog.print(index)
        }
    }
    
    func selectCategory(_ sender: UITapGestureRecognizer){
        
        let multiSelect = SHMultipleSelect()
        multiSelect.delegate = self;
        multiSelect.rowsCount = self.selectedCategoriesNames.count
        multiSelect.show()
        
    }
    
    
    
    func showPicker(title:String,rows:[String],initialSelection:Int,completionPicking:@escaping (_ value:String,_ index:Int)->Void){
        
        ActionSheetStringPicker.show(withTitle: title, rows: rows, initialSelection: initialSelection, doneBlock: { ( picker, indexes, values) in
            if let key = values as? String {
                completionPicking(key,indexes)
            }
            
        }, cancel: { (picker) in
            
        }, origin: self.view)
    }
    
    //MARK: Date Selection
    func startDateSelection(_ sender: UITapGestureRecognizer){
        
        let selectDate = Date()
        //let maxDate = Date()
        let minDate = Date()
        
        ActionSheetDatePicker.show(withTitle: "Select Start Date", datePickerMode: .date, selectedDate: selectDate, minimumDate: minDate, maximumDate: nil, doneBlock: { (picker, selectDate, orign) in
            CXLog.print(selectDate)
            self.isSelectDate  = true
            self.startDate = (selectDate as? Date)!
            self.startDateStr = self.dateToString(date: self.startDate, isDisplay: true)
            self.endDateStr = ""
            self.reloadIndex(indexs: [IndexPath(row: 5, section: 0),IndexPath(row: 6, section: 0)])
            
            
        }, cancel: { (picker) in
            
        }, origin: self.view)
    }
    
    func endDateSelection(_ sender: UITapGestureRecognizer){
        
        if !isSelectDate {
            return
        }
        
        let selectDate = Date()
        let maxDate = Date()
        
        ActionSheetDatePicker.show(withTitle: "Select End Date", datePickerMode: .date, selectedDate: self.startDate, minimumDate: startDate, maximumDate: nil, doneBlock: { (picker, selectDate, orign) in
            self.endDate = (selectDate as? Date)!
            self.endDateStr = self.dateToString(date: self.endDate, isDisplay: true)

            self.reloadIndex(indexs: [IndexPath(row: 5, section: 0),IndexPath(row: 6, section: 0)])
            
        }, cancel: { (picker) in
            
        }, origin: self.view)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let itemName = self.nameArray[indexPath.row]
        if itemName == "Upload"{
            return 150
        }
        return 80
    }
    
    func dateToString(date:Date,isDisplay:Bool) -> String{
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: date)
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        if isDisplay {
            formatter.dateFormat = "EEEE, MMM d, yyyy"

        }else{
            formatter.dateFormat = "yyyy-MM-dd"
        }
        // again convert your date to string
        return formatter.string(from: yourDate!)
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
    
    
    @IBAction func createPostBtnAction(_ sender: UIButton) {
        
        self.postAddAction()
    }
    
    func getTextFiled(row:Int,section:Int) ->PostAddTableViewCell {
        
        let indexPath = IndexPath(row: row, section: 0)
        let cell: PostAddTableViewCell = self.postAddTableVIew.cellForRow(at: indexPath) as! PostAddTableViewCell
        return cell
    }
    
    func validations(){
        
        
    }
    //    let nameArray = ["Stores","Location","Category","Offer  Title","Description","StartDate","EndDate","Upload"]
    @IBAction func poadTapAction(_ sender: UITapGestureRecognizer) {
        self.imagePickerAction()
    }

    func postAddAction(){
        
        //yyyy-MM-dd HH:mm:ss.S
        
        
        let offerTitle = self.getTextFiled(row: 3, section: 0).postAddTextField.text
        let offerDescription = self.getTextFiled(row: 4, section: 0).postAddTextField.text
        
        if (offerTitle?.isEmpty)! {
            CXDataService.sharedInstance.showAlert(message: "Pleae Enter Offer Title", viewController: self)
            return
        }
        
        if (offerDescription?.isEmpty)! {
            CXDataService.sharedInstance.showAlert(message: "Pleae Enter Offer Description", viewController: self)
            return
        }
        
        if self.startDateStr.isEmpty {
            CXDataService.sharedInstance.showAlert(message: "Pleae Select Start Date", viewController: self)
            return
        }
        
        if self.endDateStr.isEmpty {
            CXDataService.sharedInstance.showAlert(message: "Pleae Select End Date", viewController: self)
            return
        }
        
        
        
        
        if self.uploadImgview.image == nil {
            CXDataService.sharedInstance.showAlert(message: "Pleae Select Post Image", viewController: self)
            return
        }
        let imageData: Data = UIImagePNGRepresentation(self.uploadImgview.image!) as! Data
        
        
        
        let mainDict = NSMutableDictionary()
        mainDict["OfferTitle"] = offerTitle
        mainDict["OfferDescription"] = offerDescription
        mainDict["StartDate"] = self.dateToString(date: self.startDate, isDisplay: false)
        mainDict["EndDate"] = self.dateToString(date: self.endDate, isDisplay: false)
        mainDict["UserId"] = CXDataSaveManager.sharedInstance.getTheUserProfileFromDB().userId
        
        var array = NSMutableArray()
        for catDict in self.selectedCategories {
            let dic = catDict as? NSDictionary
            array.add(["DealCategories":dic?.value(forKey: "Id")])
        }
        
        
        //let array = [dict]
        mainDict["DealCategories"] = array
        
        let subDict = NSMutableDictionary()
        print(self.selectedLocation)
        subDict["StoreLocationId"] = CXAppConfig.resultString(self.selectedLocation.value(forKey: "StoreId") as AnyObject)
        subDict["IsActive"] = "true"
        let arr = [subDict]
        mainDict["DealLocations"] = arr
        
        print(mainDict)
        
        //let inputDic = ["DealCoreEntity":self.constructTheJson(ticketsInput: mainDict),"2":""]
        
        CXDataService.sharedInstance.showLoader(view: self.view, message: "Uploading...")
        CXDataService.sharedInstance.updateTheProfileAndAddThePostAdd(mainDict: mainDict, jsonKeyName: "DealCoreEntity", imageData: imageData as Data, imageKey: CXAppConfig.resultString(self.selectedStore.value(forKey: "StoreId") as AnyObject), urlString: "http://api.walk2deals.com/api/Deal/Save") { (responce) in
            CXDataService.sharedInstance.hideLoader()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadData"), object: nil)
            self.view.makeToast(message: "Uploaded Successfully")
            self.backAction(sender: UIButton())
            CXLog.print(responce)
        }
        
        /*
         yyyy-MM-dd
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
        
    }

    
    //MARK: Upload Action
    func addImgeUpload(sender:UIButton){
        self.imagePickerAction()
        
    }

    /*Image Picker Action  */
    func imagePickerAction(){
        //Create the AlertController and add Its action like button in Actionsheet
        let choosePhotosActionSheet: UIAlertController = UIAlertController(title: "Select An Option", message: nil , preferredStyle: .actionSheet)
        
        let chooseFromPhotos: UIAlertAction = UIAlertAction(title: "Choose From Photos", style: .default)
        { action -> Void in
            //print("choose from photos")
            let image = UIImagePickerController()
            image.delegate = self
            image.sourceType = .photoLibrary
            image.allowsEditing = false
            self.present(image, animated: true, completion: nil)
        }
        choosePhotosActionSheet.addAction(chooseFromPhotos)
        
        let capturePicture: UIAlertAction = UIAlertAction(title: "Capture Image", style: .default)
        { action -> Void in
            //print("camera shot")
            let picker = UIImagePickerController()
            picker.allowsEditing = false
            picker.delegate = self
            picker.sourceType = .camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            self.present(picker, animated: true, completion: nil)
        }
        choosePhotosActionSheet.addAction(capturePicture)
        
        let noImage: UIAlertAction = UIAlertAction(title: "Remove Image", style: .default)
        { action -> Void in
            //self.editImageView.image = UIImage(named: "placeholder")
            UserDefaults.standard.set(nil, forKey: "IMG_DATA")
        }
        // choosePhotosActionSheet.addAction(noImage)
        
        let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        { action -> Void in
            print("Delete")
            //self.saveButton.isHidden = true
        }
        choosePhotosActionSheet.addAction(cancel)
        
        self.present(choosePhotosActionSheet, animated: true, completion: nil)
    }
    
    /* image Picker Controller*/
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var image = UIImage()
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image = pickedImage as UIImage
            self.uploadImgview.image = image
           // self.reloadIndex(indexs: [IndexPath(row: 7, section: 0)])
            //let indexPath = IndexPath(row: 7, section: 0)
            //let cell: PostAddOneTableViewCell = self.postAddTableVIew.cellForRow(at: indexPath) as! PostAddOneTableViewCell
           // cell.addImgView.image = image
            //PostAddOneTableViewCell
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension PostAddViewController: SHMultipleSelectDelegate{
    
    func multipleSelectView(_ multipleSelectView: SHMultipleSelect!, clickedBtnAt clickedBtnIndex: Int, withSelectedIndexPaths selectedIndexPaths: [Any]!) {
        
        for index in (selectedIndexPaths as? [IndexPath])!{
            self.selectedCategories.add(self.categoriesArray[index.row])
        }
        self.postAddTableVIew.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .none)

        CXLog.print(self.selectedCategories)
    }
    
    func multipleSelectView(_ multipleSelectView: SHMultipleSelect!, titleForRowAt indexPath: IndexPath!) -> String! {
        return self.selectedCategoriesNames[indexPath.row]
    }
}

