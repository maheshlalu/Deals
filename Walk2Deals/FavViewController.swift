//
//  FavViewController.swift
//  Walk2Deals
//
//  Created by Madhav Bhogapurapu on 11/7/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class FavViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    @IBOutlet weak var favourateTableView: UITableView!
    
    
    
    var name: UITextView!
    var contactName: UITextView!
    var phoneNumber: UITextView!
    var anotherNumber: UITextView!
    var email: UITextView!
    var address: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavourateTableViewCell", for: indexPath)as? FavourateTableViewCell
        
         self.name = (cell?.name)!
         self.contactName = (cell?.contactName)!
         
         self.phoneNumber = (cell?.phoneNumber)!
         self.anotherNumber = (cell?.anotherNumber)!
         self.email = (cell?.email)!
         self.address = (cell?.address)!
        
        return cell!
    }
    func validatedTextView(){
        
        /*  if self.nameTextView.text.characters.count == 0 || self.managementTextView.text.characters.count == 0 || self.constructionTextView.text.characters.count == 0 || self.rampTextView.text.characters.count == 0 || self.parkingTextView.text.characters.count == 0 || self.streetTextView.text.characters.count == 0{
         
         showAlert()
         
         }else{
         }
         
         */
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
    }
    @IBAction func cancelAction(_ sender: Any) {
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

/*
 [12/11/17, 11:04:15 PM] Sridhar Pettela: {
 "StoreName":"TestStoreName",
 "UserId":5,
 "LocationId":1,
 "ContactPerson":"Testing",
 "ContactNumber":"8989898989",
 "Latitude":"17.690474",
 "Longitude":"83.231049",
 "Address1":"234234",
 "Address2":"23423",
 "City":"Visakhapatnam",
 "State":"AP",
 "ZipCode":"530041",
 }
 [12/11/17, 11:05:49 PM] Sridhar Pettela: http://api.walk2deals.com/api/Store/Request
 */
