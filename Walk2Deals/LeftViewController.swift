//
//  LeftViewController.swift
//  Walk2Deals
//
//  Created by apple on 23/09/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit
import RealmSwift
class LeftViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var leftTableview: UITableView!
    var nameArray = ["Home","Near By Stores","My Deals","Favourites","Invite your friends","Settings","Give us Feedback","Request For Add","Sign Out"]
    //"Rewards Points",
    
    var imageArray = ["home","nearby","my-deal","fav-menu","invite-fnds","settings","feedBack","","logout"]
    //,"rewards-points"
    @IBOutlet weak var userImage: UIImageView!
    var previousSelectedIndex  : IndexPath = IndexPath()

    @IBOutlet weak var postAdBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        self.leftTableview.register(nib, forCellReuseIdentifier: "TableViewCell")
        self.leftTableview.dataSource = self
        self.leftTableview.delegate = self
        
        let profile = CXDataSaveManager.sharedInstance.getTheUserProfileFromDB()
        if profile.isUser {
            self.postAdBtn.isHidden = true
        }else{
            nameArray = nameArray.filter { $0 != "Request For Add" }
            imageArray = imageArray.filter { $0 != "" }
        }
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.userImage.layer.cornerRadius = 50
        self.userImage.layer.borderWidth = 2
        self.userImage.layer.masksToBounds = true
    if let img =  CXDataSaveManager.sharedInstance.getTheUserProfileFromDB().image as? String{
            let url = URL(string: CXDataSaveManager.sharedInstance.getTheUserProfileFromDB().image)
            self.userImage.setImageWith(url, usingActivityIndicatorStyle: .white)
        }
        
        self.navigationController?.isNavigationBarHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return nameArray.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        cell.textLabel?.text = nameArray[indexPath.row]
       // cell.textLabel?.font = CXAppConfig.sharedInstance.appMediumFont()
        cell.imageView?.image = UIImage(named: imageArray[indexPath.row])

        leftTableview.allowsSelection = true
        
        //[cell setBackgroundColor:[UIColor clearColor]];
        cell .backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.darkGray
        leftTableview.separatorStyle = .none
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let revealController : SWRevealViewController  = self.revealViewController()
       
        previousSelectedIndex = indexPath
        //self.navController.drawerToggle()
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let itemName : String =  nameArray[indexPath.row]
        
        if itemName == "Home"{
            let homeView = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            let navCntl = UINavigationController(rootViewController: homeView)
            revealController.pushFrontViewController(navCntl, animated: true)
            
        }else if itemName == "Near By Stores"{
            let nearByVc = storyBoard.instantiateViewController(withIdentifier: "NearByDealsViewController") as! NearByDealsViewController
            let navCntl = UINavigationController(rootViewController: nearByVc)
            navCntl.title = "Near By Stores"
            revealController.pushFrontViewController(navCntl, animated: true)
        }else if itemName == "Sign Out"{
            self.showAlert("Are you sure want to logout?", status: 0)

        }else if itemName == "Settings"{
            let settingVc = storyBoard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
            let navCntl = UINavigationController(rootViewController: settingVc)
            navCntl.title = "Settings"
            //revealController.pushFrontViewController(navCntl, animated: true)
            self.present(navCntl, animated: true, completion: { 
                
            })
        }else if itemName == "Request For Add"{
            
            let settingVc = storyBoard.instantiateViewController(withIdentifier: "StoreCreationViewController") as! StoreCreationViewController
            let navCntl = UINavigationController(rootViewController: settingVc)
            navCntl.title = "Request For Add"
            self.present(navCntl, animated: true, completion: {
                
            })
        }

        

        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        leftTableview.rowHeight = 50
        return 50
        
    }

    func showAlert(_ message:String, status:Int) {
        let alert = UIAlertController(title: "Walk2Deals", message:message , preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            CXLog.print("OK Pressed")
            
            if let bundle = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: bundle)
            }
            // LFDataManager.sharedInstance.deleteTheDeviceTokenFromServer()
            let appDelVar:AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
            appDelVar.logOutFromTheApp()
            self.deleteUserDataFromRealm()
            //Truncate database
            
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive) {
            UIAlertAction in
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func deleteUserDataFromRealm(){
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    @IBAction func postAddAction(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let postAddVc = storyBoard.instantiateViewController(withIdentifier: "PostAddViewController") as! PostAddViewController
        let navCntl = UINavigationController(rootViewController: postAddVc)
        self.present(navCntl, animated: true) { 
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func editProfile(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let postAddVc = storyBoard.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        let navCntl = UINavigationController(rootViewController: postAddVc)
        self.present(navCntl, animated: true) {
            
        }
        
    }

}
